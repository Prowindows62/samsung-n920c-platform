/*
 Copyright (C) 2004-2008 Grame

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/

#ifndef __JackConstants__
#define __JackConstants__

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define VERSION "1.9.9.5"

#define BUFFER_SIZE_MAX 8192

#define JACK_PORT_NAME_SIZE 256
#define JACK_PORT_TYPE_SIZE 32

#define JACK_SERVER_CONTROL_NAME_SIZE 128
#define JACK_CLIENT_NAME_SIZE 128
#define JACK_MESSAGE_SIZE 256
#define JACK_UUID_SIZE 32
#define JACK_SESSION_COMMAND_SIZE 256

#define REAL_JACK_PORT_NAME_SIZE JACK_CLIENT_NAME_SIZE + JACK_PORT_NAME_SIZE

#ifndef PORT_NUM
#define PORT_NUM 2048
#endif

#ifndef PORT_NUM_MAX
#define PORT_NUM_MAX 4096           // The "max" value for ports used in connection manager, although port number in graph manager is dynamic
#endif

#define DRIVER_PORT_NUM 256

#ifndef PORT_NUM_FOR_CLIENT
#define PORT_NUM_FOR_CLIENT 768
#endif

#define FIRST_AVAILABLE_PORT 1

#define CONNECTION_NUM_FOR_PORT PORT_NUM_FOR_CLIENT

#ifndef CLIENT_NUM
#define CLIENT_NUM 64
#endif

#define AUDIO_DRIVER_REFNUM   0                 // Audio driver is initialized first, it will get the refnum 0
#define FREEWHEEL_DRIVER_REFNUM   1             // Freewheel driver is initialized second, it will get the refnum 1

#define JACK_DEFAULT_SERVER_NAME "default"

#define jack_server_entry "jackdmp_entry"
#define jack_client_entry "jack_client"

#define ALL_CLIENTS -1 // for notification

#define JACK_PROTOCOL_VERSION 8

#define SOCKET_TIME_OUT 2               // in sec
#define DRIVER_OPEN_TIMEOUT 5           // in sec
#define FREEWHEEL_DRIVER_TIMEOUT 10     // in sec
#define DRIVER_TIMEOUT_FACTOR    10


#define NO_PORT   0xFFFE

#define EMPTY   0xFFFD
#define FREE	0xFFFC

#endif
