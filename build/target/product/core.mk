#
# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Base configuration for communication-oriented android devices
# (phones, tablets, etc.).  If you want a change to apply to ALMOST ALL
# devices (including non-phones and non-tablets), modify
# core_minimal.mk instead. If you care about wearables, you need to modify
# core_tiny.mk in addition to core_minimal.mk.

PRODUCT_PACKAGES += \
    BasicDreams \
    BlockedNumberProvider \
    BookmarkProvider \
    Browser2 \
    Calendar \
    CalendarProvider \
    CaptivePortalLogin \
    CertInstaller \
    Contacts \
    DeskClock \
    DocumentsUI \
    DownloadProviderUi \
    Email \
    ExactCalculator \
    ExternalStorageProvider \
    FusedLocation \
    InputDevices \
    KeyChain \
    Keyguard \
    LatinIME \
    Launcher2 \
    ManagedProvisioning \
    MtpDocumentsProvider \
    PicoTts \
    PacProcessor \
    libpac \
    PrintSpooler \
    PrintRecommendationService \
    ProxyHandler \
    QuickSearchBox \
    Settings \
    SharedStorageBackup \
    StorageManager \
    Telecom \
    TeleService \
    VpnDialogs \
    MmsService

# ProfessionalAudio
PRODUCT_PACKAGES += \
    libjackshm \
    libjackserver \
    libjack \
    libjacklogger \
    androidshmservice \
    jackd \
    jack_dummy \
    jack_alsa \
    jack_opensles \
    jack_loopback \
    in \
    out \
    jack_connect \
    jack_disconnect \
    jack_lsp \
    jack_showtime \
    jack_simple_client \
    jack_transport \
    libasound \
    libglib-2.0 \
    libgthread-2.0


# e2fsprog
PRODUCT_PACKAGES += \
    e2fsck \
    resize2fs

# libexifa
PRODUCT_PACKAGES += \
    libexifa

# libjpega
PRODUCT_PACKAGES += \
    libjpega

# KeyUtils
PRODUCT_PACKAGES += \
    libkeyutils
    
# libdmverity_hashgen
PRODUCT_PACKAGES += \
    libdmverity_hashgen \
    dm_verity_hash

    
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_base.mk)
