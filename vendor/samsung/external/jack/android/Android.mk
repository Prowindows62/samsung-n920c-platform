#
# jack-1.9.9.5
#

#ifeq (true,$(call spf_check,SEC_PRODUCT_FEATURE_AUDIO_JAM,TRUE))

LOCAL_PATH := $(call my-dir)
JACK_ROOT := $(call my-dir)/..
SUPPORT_ALSA_IN_JACK := true
SUPPORT_ANDROID_REALTIME_SCHED := true
SUPPORT_JACK_USBAUDIO := true

ifeq ($(TARGET_BUILD_VARIANT),eng)
SUPPORT_JACK_LOGGER := true
endif

ifeq ($(TARGET_BOARD_PLATFORM),mrvl)
ALSA_INCLUDES := vendor/marvell/external/alsa-lib/include
else
ALSA_INCLUDES := vendor/samsung/external/alsa-lib/include
endif
#ifneq ($(filter msm% apq% ,$(TARGET_BOARD_PLATFORM)),)
WORKAROUND_QC_JACK_ALSA := true
#endif
ifeq ($(TARGET_BOARD_PLATFORM),exynos5)
WORKAROUND_SLSI_USBAUDIO_NOISE := true
endif

ifneq ($(filter msm8916 msm8952 msm8953,$(TARGET_BOARD_PLATFORM)),)
SUPPORT_LOW_PERFOMANCE_PLATFORM := true
endif

ifeq (true,$(call spf_check,SEC_PRODUCT_FEATURE_AUDIO_NUMBER_OF_SPEAKER,4))
SUPPORT_4SPEAKER := true
endif

#ifeq ($(TARGET_ARCH), arm64)
#workaround to fix compile error of zero 64bit
#JACK_STL_LDFLAGS := -Lprebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++/libs/armeabi-v7a -lgnustl_static
#JACK_STL_INCLUDES := $(JACK_ROOT)/android/cxx-stl/gnu-libstdc++/libs/armeabi-v7a/include \
#                     prebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++/libs/armeabi-v7a/include \
#                     prebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++/include
#else
#JACK_STL_LDFLAGS := -Lprebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++/libs/$(TARGET_CPU_ABI) -lgnustl_static
#JACK_STL_INCLUDES := $(JACK_ROOT)/android/cxx-stl/gnu-libstdc++/libs/$(TARGET_CPU_ABI)/include \
#                     prebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++/libs/$(TARGET_CPU_ABI)/include \
#                     prebuilts/ndk/current/sources/cxx-stl/gnu-libstdc++/include
#endif

##########################################################
# common
##########################################################

common_cflags := -O0 -g -Wall -fexceptions -fvisibility=hidden -DHAVE_CONFIG_H
common_cflags += -Wno-unused -Wno-sign-compare -Wno-deprecated-declarations -Wno-cpp
common_cppflags := -frtti -Wno-sign-promo -fcheck-new
common_shm_cflags := -O0 -g -Wall -fexceptions -DHAVE_CONFIG_H -Wno-unused
ifeq ($(TARGET_BOARD_PLATFORM),clovertrail)
common_ldflags := -ldl
else
common_ldflags :=
endif
common_c_includes := \
    $(JACK_ROOT) \
    $(JACK_ROOT)/common \
    $(JACK_ROOT)/common/jack \
    $(JACK_ROOT)/android \
    $(JACK_ROOT)/linux \
    $(JACK_ROOT)/linux/alsa \
    $(JACK_ROOT)/posix \
    bionic/libc
#    $(JACK_STL_INCLUDES)

common_libsource_server := \
    ../common/JackActivationCount.cpp \
    ../common/JackAPI.cpp \
    ../common/JackClient.cpp \
    ../common/JackConnectionManager.cpp \
    ../common/ringbuffer.c \
    JackError.cpp \
    ../common/JackException.cpp \
    ../common/JackFrameTimer.cpp \
    ../common/JackGraphManager.cpp \
    ../common/JackPort.cpp \
    ../common/JackPortType.cpp \
    ../common/JackAudioPort.cpp \
    ../common/JackMidiPort.cpp \
    ../common/JackMidiAPI.cpp \
    ../common/JackEngineControl.cpp \
    ../common/JackShmMem.cpp \
    ../common/JackGenericClientChannel.cpp \
    ../common/JackGlobals.cpp \
    ../common/JackDebugClient.cpp \
    ../common/JackTransportEngine.cpp \
    ../common/timestamps.c \
    ../common/JackTools.cpp \
    ../common/JackMessageBuffer.cpp \
    ../common/JackEngineProfiling.cpp \
    JackAndroidThread.cpp \
    JackAndroidSemaphore.cpp \
    ../posix/JackPosixProcessSync.cpp \
    ../posix/JackPosixMutex.cpp \
    ../posix/JackSocket.cpp \
    ../linux/JackLinuxTime.c

common_libsource_client := \
    ../common/JackActivationCount.cpp \
    ../common/JackAPI.cpp \
    ../common/JackClient.cpp \
    ../common/JackConnectionManager.cpp \
    ../common/ringbuffer.c \
    JackError.cpp \
    ../common/JackException.cpp \
    ../common/JackFrameTimer.cpp \
    ../common/JackGraphManager.cpp \
    ../common/JackPort.cpp \
    ../common/JackPortType.cpp \
    ../common/JackAudioPort.cpp \
    ../common/JackMidiPort.cpp \
    ../common/JackMidiAPI.cpp \
    ../common/JackEngineControl.cpp \
    ../common/JackShmMem.cpp \
    ../common/JackGenericClientChannel.cpp \
    ../common/JackGlobals.cpp \
    ../common/JackDebugClient.cpp \
    ../common/JackTransportEngine.cpp \
    ../common/timestamps.c \
    ../common/JackTools.cpp \
    ../common/JackMessageBuffer.cpp \
    ../common/JackEngineProfiling.cpp \
    JackAndroidThread.cpp \
    JackAndroidSemaphore.cpp \
    ../posix/JackPosixProcessSync.cpp \
    ../posix/JackPosixMutex.cpp \
    ../posix/JackSocket.cpp \
    ../linux/JackLinuxTime.c

server_libsource := \
    ../common/JackAudioDriver.cpp \
    ../common/JackTimedDriver.cpp \
    ../common/JackMidiDriver.cpp \
    ../common/JackDriver.cpp \
    ../common/JackEngine.cpp \
    ../common/JackExternalClient.cpp \
    ../common/JackFreewheelDriver.cpp \
    ../common/JackInternalClient.cpp \
    ../common/JackServer.cpp \
    ../common/JackThreadedDriver.cpp \
    ../common/JackRestartThreadedDriver.cpp \
    ../common/JackWaitThreadedDriver.cpp \
    ../common/JackServerAPI.cpp \
    ../common/JackDriverLoader.cpp \
    ../common/JackServerGlobals.cpp \
    ../common/JackControlAPI.cpp \
    JackControlAPIAndroid.cpp \
    ../common/JackNetTool.cpp \
    ../common/JackNetInterface.cpp \
    ../common/JackArgParser.cpp \
    ../common/JackRequestDecoder.cpp \
    ../common/JackMidiAsyncQueue.cpp \
    ../common/JackMidiAsyncWaitQueue.cpp \
    ../common/JackMidiBufferReadQueue.cpp \
    ../common/JackMidiBufferWriteQueue.cpp \
    ../common/JackMidiRawInputWriteQueue.cpp \
    ../common/JackMidiRawOutputWriteQueue.cpp \
    ../common/JackMidiReadQueue.cpp \
    ../common/JackMidiReceiveQueue.cpp \
    ../common/JackMidiSendQueue.cpp \
    ../common/JackMidiUtil.cpp \
    ../common/JackMidiWriteQueue.cpp \
    ../posix/JackSocketServerChannel.cpp \
    ../posix/JackSocketNotifyChannel.cpp \
    ../posix/JackSocketServerNotifyChannel.cpp \
    ../posix/JackNetUnixSocket.cpp

net_libsource := \
    ../common/JackNetAPI.cpp \
    ../common/JackNetInterface.cpp \
    ../common/JackNetTool.cpp \
    ../common/JackException.cpp \
    ../common/JackAudioAdapterInterface.cpp \
    ../common/JackLibSampleRateResampler.cpp \
    ../common/JackResampler.cpp \
    ../common/JackGlobals.cpp \
    ../posix/JackPosixMutex.cpp \
    ../common/ringbuffer.c \
    ../posix/JackNetUnixSocket.cpp \
    JackAndroidThread.cpp \
    ../linux/JackLinuxTime.c

client_libsource := \
    ../common/JackLibClient.cpp \
    ../common/JackControlLibClient.cpp \
    ../common/JackLibAPI.cpp \
    ../posix/JackSocketClientChannel.cpp \
    ../posix/JackPosixServerLaunch.cpp

netadapter_libsource := \
    ../common/JackResampler.cpp \
    ../common/JackLibSampleRateResampler.cpp \
    ../common/JackAudioAdapter.cpp \
    ../common/JackAudioAdapterInterface.cpp \
    ../common/JackNetAdapter.cpp

audioadapter_libsource := \
    ../common/JackResampler.cpp \
    ../common/JackLibSampleRateResampler.cpp \
    ../common/JackAudioAdapter.cpp \
    ../common/JackAudioAdapterInterface.cpp \
    ../common/JackAudioAdapterFactory.cpp \
    ../linux/alsa/JackAlsaAdapter.cpp

ifeq ($(SUPPORT_ANDROID_REALTIME_SCHED), true)
sched_c_include := bionic/libc/bionic \
    frameworks/av/services/audioflinger
endif

ifeq ($(SUPPORT_JACK_LOGGER), true)
# ========================================================
# libjacklogger
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := JackLogger.cpp
LOCAL_CFLAGS := -O0 -g -Wall
LOCAL_LDFLAGS := -ldl $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libutils
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := libjacklogger
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)
endif

# ========================================================
# libjackserver.so
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(common_libsource_server) $(server_libsource)
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes) frameworks/av/media/utils/include
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libutils libjackshm
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := libjackserver
ifeq ($(SUPPORT_ANDROID_REALTIME_SCHED), true)
LOCAL_CFLAGS += -DJACK_ANDROID_REALTIME_SCHED
LOCAL_C_INCLUDES += $(sched_c_include)
LOCAL_SHARED_LIBRARIES += libbinder
LOCAL_SHARED_LIBRARIES += libmediautils
endif
ifeq ($(SUPPORT_JACK_USBAUDIO), true)
LOCAL_CFLAGS += -DSUPPORT_JACK_USBAUDIO
endif
ifeq ($(SUPPORT_JACK_LOGGER), true)
LOCAL_SHARED_LIBRARIES += libjacklogger
LOCAL_CFLAGS += -DENABLE_JACK_LOGGER
endif
ifeq ($(WORKAROUND_QC_JACK_ALSA), true)
LOCAL_CFLAGS += -DWORKAROUND_QC_JACK_ALSA
endif
ifeq ($(SUPPORT_LOW_PERFOMANCE_PLATFORM), true)
LOCAL_CFLAGS += -DMID_ASYNC_MODE
endif
ifneq ($(filter poseidon% a8%, $(TARGET_PRODUCT)),)
LOCAL_CFLAGS += -DMID_ASYNC_MODE
endif
ifeq ($(SUPPORT_4SPEAKER), true)
LOCAL_CFLAGS += -DUSE_4SPEAKER
endif
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

## ========================================================
## libjacknet.so
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := $(net_libsource)
#LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libsamplerate
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := libjacknet
#
#include $(BUILD_SHARED_LIBRARY)

# ========================================================
# libjack.so
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(common_libsource_client) $(client_libsource)
LOCAL_CFLAGS := $(common_cflags)
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes) frameworks/av/media/utils/include
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libutils libjackshm
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := libjack

LOCAL_PROPRIETARY_MODULE := true

ifeq ($(SUPPORT_ANDROID_REALTIME_SCHED), true)
LOCAL_CFLAGS += -DJACK_ANDROID_REALTIME_SCHED
ifeq ($(SUPPORT_JACK_LOGGER), true)
LOCAL_CFLAGS += -DENABLE_JACK_LOGGER
endif
LOCAL_C_INCLUDES += $(sched_c_include)
LOCAL_SHARED_LIBRARIES += libbinder
LOCAL_SHARED_LIBRARIES += libmediautils
endif
#ifeq ($(TARGET_ARCH), arm64)
#LOCAL_MULTILIB := 32
#endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# netmanager.so
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../common/JackNetManager.cpp
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := netmanager
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# profiler.so
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../common/JackProfiler.cpp
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := profiler
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

## ========================================================
## netadapter.so
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := $(netadapter_libsource)
#LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libsamplerate libjackserver
#LOCAL_MODULE_RELATIVE_PATH := jack
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := netadapter
#
#include $(BUILD_SHARED_LIBRARY)

## ========================================================
## audioadapter.so
## ========================================================
#ifeq ($(SUPPORT_ALSA_IN_JACK),true)
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := $(audioadapter_libsource)
#LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE -D_POSIX_SOURCE
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include $(ALSA_INCLUDES)
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libasound libsamplerate libjackserver
#LOCAL_MODULE_RELATIVE_PATH := jack
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := audioadapter
#
#include $(BUILD_SHARED_LIBRARY)
##endif

# ========================================================
# in.so - sapaproxy internal client
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := JackSapaProxy.cpp JackSapaProxyIn.cpp
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := in
#ifeq ($(TARGET_BOARD_PLATFORM),exynos5)
#LOCAL_SHARED_LIBRARIES += libmedia
#LOCAL_CFLAGS += -DNEED_AUDIO_TUNING
#endif
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# out.so - sapaproxy internal client
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := JackSapaProxy.cpp JackSapaProxyOut.cpp
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := out
#ifeq ($(TARGET_BOARD_PLATFORM),exynos5)
#LOCAL_SHARED_LIBRARIES += libmedia
#LOCAL_CFLAGS += -DNEED_AUDIO_TUNING
#endif
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

##########################################################
# linux
##########################################################

# ========================================================
# jackd
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ../common/Jackdmp.cpp
#    ../dbus/reserve.c
#    ../dbus/audio_reserve.c
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
#ifeq ($(SUPPORT_JACK_LOGGER), true)
#LOCAL_CFLAGS += -DENABLE_JACK_LOGGER
#endif
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(JACK_STL_LDFLAGS) -ldl -Wl,--no-fatal-warnings
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libutils libjackserver
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jackd
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# driver - dummy
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../common/JackDummyDriver.cpp
#'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
ifeq ($(SUPPORT_JACK_LOGGER), true)
LOCAL_CFLAGS += -DENABLE_JACK_LOGGER
endif
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_dummy
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# driver - alsa
# ========================================================
ifeq ($(SUPPORT_ALSA_IN_JACK),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ../linux/alsa/JackAlsaDriver.cpp \
    ../linux/alsa/alsa_midi_jackmp.cpp \
    ../common/memops.c \
    ../linux/alsa/generic_hw.c \
    ../linux/alsa/hdsp.c \
    ../linux/alsa/alsa_driver.c \
    ../linux/alsa/hammerfall.c \
    ../linux/alsa/ice1712.c
#    ../linux/alsa/alsa_rawmidi.c
#    ../linux/alsa/alsa_seqmidi.c
#'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE -D_POSIX_SOURCE -D_XOPEN_SOURCE=600
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes) $(ALSA_INCLUDES)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver libasound
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_alsa
ifeq ($(WORKAROUND_SLSI_USBAUDIO_NOISE), true)
LOCAL_CFLAGS += -DWORKAROUND_SLSI_USBAUDIO_NOISE
endif
ifeq ($(SUPPORT_JACK_LOGGER), true)
LOCAL_SHARED_LIBRARIES += libjacklogger
LOCAL_CFLAGS += -DENABLE_JACK_LOGGER
endif
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)
endif

## ========================================================
## driver - alsarawmidi
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := \
#    ../linux/alsarawmidi/JackALSARawMidiDriver.cpp \
#    ../linux/alsarawmidi/JackALSARawMidiInputPort.cpp \
#    ../linux/alsarawmidi/JackALSARawMidiOutputPort.cpp \
#    ../linux/alsarawmidi/JackALSARawMidiPort.cpp \
#    ../linux/alsarawmidi/JackALSARawMidiReceiveQueue.cpp \
#    ../linux/alsarawmidi/JackALSARawMidiSendQueue.cpp \
#    ../linux/alsarawmidi/JackALSARawMidiUtil.cpp
##'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
#LOCAL_CFLAGS := $(common_cflags) -D_POSIX_SOURCE -D__ALSA_RAWMIDI_H
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes) $(ALSA_INCLUDES)
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver libasound
#LOCAL_MODULE_RELATIVE_PATH := jack
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_alsarawmidi
#
#include $(BUILD_SHARED_LIBRARY)

## LIBFREEBOB required
## ========================================================
## driver - freebob
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../linux/freebob/JackFreebobDriver.cpp
##'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
#LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes)
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
#LOCAL_MODULE_RELATIVE_PATH := jack
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_freebob
#
#include $(BUILD_SHARED_LIBRARY)

## LIBFFADO required
## ========================================================
## driver - firewire
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := \
#    ../linux/firewire/JackFFADODriver.cpp \
#    ../linux/firewire/JackFFADOMidiInputPort.cpp \
#    ../linux/firewire/JackFFADOMidiOutputPort.cpp \
#    ../linux/firewire/JackFFADOMidiReceiveQueue.cpp \
#    ../linux/firewire/JackFFADOMidiSendQueue.cpp
##'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
#LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes)
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
#LOCAL_MODULE_RELATIVE_PATH := jack
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_firewire
#
#include $(BUILD_SHARED_LIBRARY)

# ========================================================
# driver - net
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../common/JackNetDriver.cpp
#'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_net
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# driver - loopback
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../common/JackLoopbackDriver.cpp
#'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_loopback
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

##HAVE_SAMPLERATE, HAVE_CELT required
## ========================================================
## driver - netone
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := \
#    ../common/JackNetOneDriver.cpp \
#    ../common/netjack.c \
#    ../common/netjack_packet.c
##'HAVE_CONFIG_H','SERVER_SIDE', 'HAVE_PPOLL', 'HAVE_TIMERFD
#LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
#LOCAL_CPPFLAGS := $(common_cppflags)
#LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include
#LOCAL_SHARED_LIBRARIES := libc libdl libcutils libsamplerate libjackserver
#LOCAL_MODULE_RELATIVE_PATH := jack
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_netone
#
#include $(BUILD_SHARED_LIBRARY)

##########################################################
# android
##########################################################

# ========================================================
# libjackshm.so
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := BnAndroidShm.cpp BpAndroidShm.cpp IAndroidShm.cpp AndroidShm.cpp Shm.cpp
LOCAL_CFLAGS := $(common_shm_cflags) -DSERVER_SIDE
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libutils libbinder
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := libjackshm
#ifeq ($(TARGET_ARCH), arm64)
#LOCAL_MULTILIB := 32
#endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# jack_goldfish.so - Goldfish driver for emulator
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := JackGoldfishDriver.cpp
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_goldfish
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

# ========================================================
# jack_opensles.so - OpenSL ES driver
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := JackOpenSLESDriver.cpp opensl_io.c
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes) frameworks/wilhelm/include
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver libOpenSLES
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_opensles
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

##########################################################
# android/AndroidShmServer
##########################################################

# ========================================================
# androidshmservice
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ./AndroidShmServer/main_androidshmservice.cpp
LOCAL_CFLAGS := $(common_cflags)
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libcutils libutils libbinder libjackshm
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE:= androidshmservice
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# shmservicetest
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ./AndroidShmServer/test/shmservicetest.cpp
LOCAL_CFLAGS := $(common_cflags) -DLOG_TAG=\"ShmServiceTest\"
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libcutils libutils libjackshm libbinder
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := shmservicetest
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif
include $(BUILD_EXECUTABLE)

# ========================================================
# shmservicedump
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ./AndroidShmServer/test/shmservicedump.cpp
LOCAL_CFLAGS := $(common_cflags) -DLOG_TAG=\"ShmServiceDump\"
LOCAL_CPPFLAGS := $(common_cppflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_SHARED_LIBRARIES := libcutils libutils libjackshm libbinder
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := shmservicedump
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

##########################################################
# example-clients
##########################################################

# ========================================================
# jack_freewheel
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/freewheel.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_freewheel
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_connect
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/connect.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_connect
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

# Avoid racing condition : create connect.d and connect.P also created by jack_disconnect
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_OPTIONAL_EXECUTABLES)/jack_disconnect

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_disconnect
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/connect.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_disconnect
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_lsp
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/lsp.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_lsp
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_metro
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/metro.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_metro
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_midiseq
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/midiseq.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_midiseq
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_midisine
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/midisine.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_midisine
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_showtime
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/showtime.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_showtime
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_simple_client
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/simple_client.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_simple_client
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_zombie
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/zombie.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_zombie
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_load
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/ipload.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_load
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_unload
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/ipunload.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_unload
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_alias
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/alias.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_alias
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_bufsize
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/bufsize.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_bufsize
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_wait
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/wait.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_wait
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_samplerate
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/samplerate.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_samplerate
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_evmon
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/evmon.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_evmon
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_monitor_client
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/monitor_client.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_monitor_client
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_thru
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/thru_client.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_thru
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_cpu_load
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/cpu_load.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_cpu_load
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_simple_session_client
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/simple_session_client.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_simple_session_client
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_session_notify
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/session_notify.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_session_notify
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_server_control
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/server_control.cpp
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjackserver
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_server_control
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

## ========================================================
## jack_net_slave
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../example-clients/netslave.c
#LOCAL_CFLAGS := $(common_cflags)
#LOCAL_LDFLAGS := $(common_ldflags)
#LOCAL_C_INCLUDES := $(common_c_includes)
#LOCAL_SHARED_LIBRARIES := libjacknet
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_net_slave
#
#include $(BUILD_EXECUTABLE)

## ========================================================
## jack_net_master
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../example-clients/netmaster.c
#LOCAL_CFLAGS := $(common_cflags)
#LOCAL_LDFLAGS := $(common_ldflags)
#LOCAL_C_INCLUDES := $(common_c_includes)
#LOCAL_SHARED_LIBRARIES := libjacknet
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_net_master
#
#include $(BUILD_EXECUTABLE)

# ========================================================
# jack_latent_client
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/latent_client.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_latent_client
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_midi_dump
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/midi_dump.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_midi_dump
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_midi_latency_test
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/midi_latency_test.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_midi_latency_test
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_transport
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/transport.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_transport
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

## ========================================================
## jack_rec
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../example-clients/capture_client.c
#LOCAL_CFLAGS := $(common_cflags)
#LOCAL_LDFLAGS := $(common_ldflags)
#LOCAL_C_INCLUDES := $(common_c_includes)  $(JACK_ROOT)/../libsndfile/src
#LOCAL_SHARED_LIBRARIES := libjack libsndfile
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_rec
#
#include $(BUILD_EXECUTABLE)

## ========================================================
## jack_netsource
## ========================================================
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../example-clients/netsource.c  ../common/netjack_packet.c
#LOCAL_CFLAGS := $(common_cflags) -DNO_JACK_ERROR
#LOCAL_LDFLAGS := $(common_ldflags)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include
#LOCAL_SHARED_LIBRARIES := libsamplerate libjack
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := jack_netsource
#
#include $(BUILD_EXECUTABLE)

## ========================================================
## alsa_in
## ========================================================
#ifeq ($(SUPPORT_ALSA_IN_JACK),true)
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../example-clients/alsa_in.c  ../common/memops.c
#LOCAL_CFLAGS := $(common_cflags) -DNO_JACK_ERROR -D_POSIX_SOURCE -D_XOPEN_SOURCE=600
#LOCAL_LDFLAGS := $(common_ldflags)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include $(ALSA_INCLUDES)
#LOCAL_SHARED_LIBRARIES := libasound libsamplerate libjack
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := alsa_in
#
#include $(BUILD_EXECUTABLE)
#endif

## ========================================================
## alsa_out
## ========================================================
#ifeq ($(SUPPORT_ALSA_IN_JACK),true)
#include $(CLEAR_VARS)
#
#LOCAL_SRC_FILES := ../example-clients/alsa_out.c  ../common/memops.c
#LOCAL_CFLAGS := $(common_cflags) -DNO_JACK_ERROR -D_POSIX_SOURCE -D_XOPEN_SOURCE=600
#LOCAL_LDFLAGS := $(common_ldflags)
#LOCAL_C_INCLUDES := $(common_c_includes) $(JACK_ROOT)/../libsamplerate/include $(ALSA_INCLUDES)
#LOCAL_SHARED_LIBRARIES := libasound libsamplerate libjack
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#LOCAL_MODULE_TAGS := eng optional
#LOCAL_MODULE := alsa_out
#
#include $(BUILD_EXECUTABLE)
#endif

# ========================================================
# inprocess
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../example-clients/inprocess.c
LOCAL_CFLAGS := $(common_cflags) -DSERVER_SIDE
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libc libdl libcutils libjackserver
LOCAL_MODULE_RELATIVE_PATH := jack
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := inprocess
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_SHARED_LIBRARY)

##########################################################
# tests
##########################################################

# ========================================================
# jack_test
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../tests/test.cpp
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack libjackshm
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_test
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_cpu
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../tests/cpu.c
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack libjackshm
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_cpu
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_iodelay
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../tests/iodelay.cpp
LOCAL_CFLAGS := $(common_cflags)
LOCAL_CFLAGS += -Wno-narrowing
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack libjackshm
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_iodelay
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

# ========================================================
# jack_multiple_metro
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ../tests/external_metro.cpp
LOCAL_CFLAGS := $(common_cflags)
LOCAL_LDFLAGS := $(common_ldflags) $(JACK_STL_LDFLAGS)
LOCAL_C_INCLUDES := $(common_c_includes)
LOCAL_SHARED_LIBRARIES := libjack libjackshm
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng optional
LOCAL_MODULE := jack_multiple_metro
ifeq ($(TARGET_ARCH), arm64)
LOCAL_MULTILIB := 32
endif

include $(BUILD_EXECUTABLE)

#endif
