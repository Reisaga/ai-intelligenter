export THEOS ?= $(THEOS)

ARCHS = arm64
TARGET = iphone:clang

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mona

mona_FILES = Menu.mm

mona_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics AudioToolbox

mona_CCFLAGS = -std=c++17 \
    -fno-rtti \
    -fno-exceptions \
    -DNDEBUG \
    -O2 \
    -ISource/Includes

Brazilix_CFLAGS = \
    -fobjc-arc \
    -Wno-deprecated-declarations \
    -Wno-unused-variable \
    -Wno-unused-value \
    -Wno-incomplete-umbrella \
    -ISource/Includes

Brazilix_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
