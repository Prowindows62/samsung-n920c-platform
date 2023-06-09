#define LOG_TAG "JAMSHMSERVICE"

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <binder/IPCThreadState.h>
#include <binder/MemoryHeapBase.h>
#include <binder/IServiceManager.h>
#include <binder/IPCThreadState.h>
#include <utils/Log.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <sys/wait.h>
#include "BnAndroidShm.h"
#include "AndroidShm.h"


#include "JackConstants.h"


#include <fcntl.h>
#include <signal.h>
#include <limits.h>
#include <errno.h>
#include <dirent.h>
#include <sys/mman.h>
#include <linux/ashmem.h>
#include <cutils/ashmem.h>

#include "JackError.h"

#include <semaphore.h>


#define MEMORY_SIZE 10*1024

#define SEMAPHORE_NULL_CHAR '\0'

// remove ALOGI log
#undef  ALOGI
#define ALOGI 

namespace android {

#define INVALID_PID 0

    int AndroidShm::instantiate() {
        defaultServiceManager()->addService(String16("com.samsung.android.jam.IAndroidShm"), new AndroidShm); // SINGLETON WITH SAME NAME
        return 0;
    }

    int AndroidShm::sendCommand(const char* command) {

        if( NULL == command ){
            ALOGE("E(pid:%d) send command is NULL\n", getpid());
            return BAD_VALUE;
        }

        ALOGI("I(pid:%d) send command is %s\n", getpid(), command);
        if(strcmp(command, "semaphore") == 0) {
            // print debug message about semaphore simulation
            for(int i = MAX_SEMAPHORE_MEMORY_COUNT -1 ; i >= 0; i--) {
                printf("index[%3d] = ptr[%p] name[%s]\n", i, (mSemaphore[i] != NULL)?mSemaphore[i]->getBase():0, mSemaphoreName[i]);
                ALOGI("index[%3d] = ptr[%p] name[%s]\n", i, (mSemaphore[i] != NULL)?mSemaphore[i]->getBase():0, mSemaphoreName[i]);
            }
        }
        return NO_ERROR;
    }

    int AndroidShm::testGetBufferByNewProcess() {
        ALOGI("testGetBufferByNewProcess...");
        int status;
        int childPid = fork();
        
        if(childPid > 0) {
            ALOGI("I(pid%d) made a child process(pid:%d)", getpid(), childPid);
            ALOGI("I(pid%d) wait until child(%d) was finish", getpid(), childPid);
            wait(&status);
            // wait 하지 않으면 child process가 남아 있음. 
            ALOGI("child(%d) was finished. ", childPid);
        } else if(childPid == 0) {
            ALOGI("im a new child process(pid:%d) ", getpid());
            if(-1 == execlp("/system/bin/getbufferclient","getbufferclient",NULL)) {
                ALOGE("failed to execute getbufferclient");
            }
            exit(0);
        } else {
            ALOGI("failed creating child process");
        } 
        return 0;
    }

    int AndroidShm::testGetBuffer() {
        ALOGI("I(pid:%d) trying to test get buffer...", getpid());
        sp<IServiceManager> sm = defaultServiceManager();
        ALOGI("get default ServiceManager is done");
        sp<IBinder> b;
        //String16* serviceName = new String16("com.samsung.android.jam.IAndroidShm");
        do {
            //ALOGI("here");
            b = sm->getService(String16("com.samsung.android.jam.IAndroidShm"));
            //ALOGI("getservice is done");
            
            if(b != 0)
                break;
            //ALOGI("AndroidShm is not working, waiting...");
            usleep(500000);
                
        } while(true);
                
        sp<IAndroidShm> service = interface_cast<IAndroidShm>(b);

        //shared buffer.
        sp<IMemoryHeap> receiverMemBase = service->getBuffer(0);
        
        unsigned int *base = (unsigned int *) receiverMemBase->getBase();
        int ret = 0;
        if(base != (unsigned int *) -1) {
            ALOGD("AndroidShm::testGetBuffer base=%p Data=0x%x\n",base, *base);
            *base = (*base)+1;
            ret = (unsigned int)(*base);
            ALOGI("AndroidShm::testGetBuffer base=%p Data=0x%x CHANGED\n",base, *base);
            receiverMemBase = 0;
        } else {
            ALOGE("Error shared memory not available\n");
        }
        return 0;
    }

    sp<IMemoryHeap> AndroidShm::getBuffer(int index) {
        ALOGI("I(pid:%d) getBuffer index:%d", getpid(), index);
        if(index < 0 || index >= MAX_SHARED_MEMORY_COUNT) {
            ALOGE("error : out of index [%d]", index);
            return NULL;
        }
        return mMemHeap[index];
    }

    int AndroidShm::MemAlloc(unsigned int size) {
		ALOGI("try to allocate memory size[%d]", size);
        for(int i = 0; i < MAX_SHARED_MEMORY_COUNT; i++) {
            if(mMemHeap[i] == NULL) {
                mMemHeap[i] = new MemoryHeapBase(size);
                if(mMemHeap[i] == NULL){
					ALOGE("fail to alloc, try one more...");
					continue; // try one more.
                }
                return i;
            }
        }
		ALOGE("fail to MemAlloc size %d", size);
        return -1; // fail to alloc
    }

    AndroidShm::AndroidShm() {
        ALOGI("AndroidShm is created");
        for(int i = 0; i < MAX_SHARED_MEMORY_COUNT; i++) {
            mMemHeap[i] = NULL;
			mCallingPids[i] = INVALID_PID;
        }
        mRegistryIndex = 10000;
        //mMemHeap = new MemoryHeapBase(MEMORY_SIZE);
        //unsigned int *base = (unsigned int*) mMemHeap->getBase();
        //*base = 0xdeadcafe;//

        for(int j = 0; j < MAX_SEMAPHORE_MEMORY_COUNT; j++) {
            mSemaphore[j] = NULL;
            memset(mSemaphoreName[j], SEMAPHORE_NULL_CHAR, MAX_SEMAPHORE_NAME_LENGTH);
			mSemaphorePids[j] = INVALID_PID;
        }
    }

    AndroidShm::~AndroidShm() {
        ALOGI("AndroidShm is destroyed");
        for(int i = 0; i < MAX_SHARED_MEMORY_COUNT; i++) {
			(mMemHeap[i]).clear();
        }
        for(int j = 0; j < MAX_SEMAPHORE_MEMORY_COUNT; j++) {
			(mSemaphore[j]).clear();
        }
    }

    //status_t AndroidShm::onTransact(uint32_t code, const Parcel& data, Parcel* reply, uint32_t flags) {
    //    return BnAndroidShm::onTransact(code, data, reply, flags);
    //}

    int AndroidShm::allocShm(const int size) { // if negative return value is error
    	ALOGI("try to alloc shared memory size[%d]", size);
		const int allocatedIndex = MemAlloc(size);
		setCallingPid(allocatedIndex);
		//ALOGW("AndroidShm allocated index = %d", allocatedIndex);
		return allocatedIndex;
    }
    
    int AndroidShm::removeShm(const unsigned int index) { // shared memory 제거 
    	ALOGI("try to remove shared memory index[%d]", index);
        if(index >= MAX_SHARED_MEMORY_COUNT) {
            ALOGE("remove shared memory: out of index");
            return -1;
        }

		if(isRemoveShmAllowed(index)){
			//ALOGW("AndroidShm shm index = %d was removed", index);
			(mMemHeap[index]).clear();
			mCallingPids[index] = INVALID_PID;
		} else {
			ALOGE("remove shared memory: no permission index = %d", index);
			return -1;
		}
        return 1;
    }

	bool AndroidShm::isRemoveShmAllowed(const int index){
        const IPCThreadState* ipc = IPCThreadState::self();
		if(ipc == NULL){
			ALOGE("thread status is null.");
			return false;
		}
		
		// Only the creator can remove.
		if(ipc->getCallingPid() == mCallingPids[index]){
			return true;
		} else {
			return false;
		}
	}

    int AndroidShm::isAllocated(const unsigned int index) { // allocated 여부 확인
    	ALOGI("try to check the memory allocation index[%d]", index);
        if(index >= MAX_SHARED_MEMORY_COUNT) {
            ALOGE("shared memory: out of index");
            return 0;
        }
        if(mMemHeap[index] == NULL)
            return 0;
        else
            return 1;
    }

    int AndroidShm::setRegistryIndex(const unsigned int index) {
		ALOGI("set registry index %d", index);
        mRegistryIndex = index;
        return 1;
    }
    
    int AndroidShm::getRegistryIndex() {
        return mRegistryIndex;
    }

    sp<IMemoryHeap> AndroidShm::InitSemaphore(const char* name) {
		ALOGW("init semaphore [%s]", name);
        if(name == NULL || strlen(name) <= 0){
            ALOGE("InitSemaphore invalid name return NULL");
            return NULL;
        }
        
        for(int i = 0; i < MAX_SEMAPHORE_MEMORY_COUNT; i++) {
            if(mSemaphoreName[i][0] == SEMAPHORE_NULL_CHAR) {
                mSemaphore[i] = new MemoryHeapBase(sizeof(sem_t));
				if(mSemaphore[i] == NULL){
					ALOGE("fail to alloc, try one more...");
					continue;
				}
                if(sem_init((sem_t*)(mSemaphore[i]->getBase()), 1, 0) == 0) {
                    strncpy(mSemaphoreName[i], name, MAX_SEMAPHORE_NAME_LENGTH - 1);
                    mSemaphoreName[i][MAX_SEMAPHORE_NAME_LENGTH - 1] = '\0';
					const IPCThreadState* ipc = IPCThreadState::self();
					if(ipc != NULL){
						mSemaphorePids[i] = ipc->getCallingPid();
						}
					ALOGW("sem_init success");
                    return mSemaphore[i];
                } else {
                	(mSemaphore[i]).clear();
					ALOGE("sem_init failed null returned");
                    return NULL;
                }
            } else {
                // find already exist name
                if(strcmp(mSemaphoreName[i], name) == 0) { // found
                	ALOGI("found - return already allocated semaphore");
                    return mSemaphore[i];
                }
				if(kill(mSemaphorePids[i], 0) == -1 && errno == ESRCH ){ // check that the UI process is alive
					ALOGW("sem_alloc");
					(mSemaphore[i]).clear();
					mSemaphorePids[i] = INVALID_PID;
            		memset(mSemaphoreName[i], SEMAPHORE_NULL_CHAR, MAX_SEMAPHORE_NAME_LENGTH);
					i--;
				}
            }
       }
		ALOGE("sem_init failed null returned 2");
    	return NULL;	
    }

	void AndroidShm::setCallingPid(int index){
        const IPCThreadState* ipc = IPCThreadState::self();
		if(ipc != NULL && index >= 0 && index < MAX_SHARED_MEMORY_COUNT){
			mCallingPids[index] = ipc->getCallingPid();
		}
	}

};

