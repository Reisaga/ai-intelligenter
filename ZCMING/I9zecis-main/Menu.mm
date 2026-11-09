#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <substrate.h>


#import "Includes/Vector3.h"
#import "Includes/Vector2.h"
#import "Includes/Quaternion.h"
#import "Includes/UnityTypes.h"
#import "Includes/MemoryUtils.h"
#import "Includes/ESP.h"
#import "Includes/Encryption.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


#define COLOR_BG        [UIColor colorWithRed:0.11 green:0.11 blue:0.13 alpha:0.97]
#define COLOR_PANEL     [UIColor colorWithRed:0.14 green:0.14 blue:0.16 alpha:1.0]
#define COLOR_SIDEBAR   [UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:1.0]
#define COLOR_ACCENT    [UIColor colorWithRed:1.0  green:0.38 blue:0.10 alpha:1.0]
#define COLOR_ROW       [UIColor colorWithRed:0.18 green:0.18 blue:0.21 alpha:1.0]
#define COLOR_TEXT      [UIColor whiteColor]
#define COLOR_SUBTEXT   [UIColor colorWithWhite:0.55 alpha:1.0]

typedef NS_ENUM(NSInteger, MenuTab) {
    MenuTabAimbot   = 0,
    MenuTabESP      = 1,
    MenuTabMisc     = 2,
    MenuTabSettings = 3,
    MenuTabProfile  = 4,
};


static UIImage *ZSFImage(NSString *name, CGFloat size) {
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *cfg = [UIImageSymbolConfiguration
            configurationWithPointSize:size weight:UIImageSymbolWeightMedium];
        return [[UIImage systemImageNamed:name withConfiguration:cfg]
                imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.6 alpha:1.0].CGColor);
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, size, size));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@interface ZToggleRow : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *toggleTrack;
@property (nonatomic, strong) UIView  *toggleThumb;
@property (nonatomic, assign) BOOL     isOn;
@property (nonatomic, copy)   void (^onToggle)(BOOL isOn);
- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)on;
@end

@implementation ZToggleRow
- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)on {
    self = [super init];
    if (!self) return nil;
    _isOn = on;
    self.backgroundColor = COLOR_ROW;
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = title;
    _titleLabel.textColor = COLOR_TEXT;
    _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];

    _toggleTrack = [[UIView alloc] init];
    _toggleTrack.layer.cornerRadius = 13;
    _toggleTrack.clipsToBounds = YES;
    _toggleTrack.translatesAutoresizingMaskIntoConstraints = NO;
    _toggleTrack.backgroundColor = on ? COLOR_ACCENT : [UIColor colorWithWhite:0.3 alpha:1.0];
    [self addSubview:_toggleTrack];

    _toggleThumb = [[UIView alloc] init];
    _toggleThumb.layer.cornerRadius = 11;
    _toggleThumb.backgroundColor = UIColor.whiteColor;
    _toggleThumb.translatesAutoresizingMaskIntoConstraints = NO;
    [_toggleTrack addSubview:_toggleThumb];

    [NSLayoutConstraint activateConstraints:@[
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14],
        [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_toggleTrack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14],
        [_toggleTrack.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_toggleTrack.widthAnchor constraintEqualToConstant:42],
        [_toggleTrack.heightAnchor constraintEqualToConstant:26],
        [_toggleThumb.centerYAnchor constraintEqualToAnchor:_toggleTrack.centerYAnchor],
        [_toggleThumb.widthAnchor constraintEqualToConstant:22],
        [_toggleThumb.heightAnchor constraintEqualToConstant:22],
    ]];
    [self _applyThumbPosition:NO];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(_tapped)];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)_tapped {
    _isOn = !_isOn;
    _toggleTrack.backgroundColor = _isOn ? COLOR_ACCENT : [UIColor colorWithWhite:0.3 alpha:1.0];
    [self _applyThumbPosition:YES];
    if (_onToggle) _onToggle(_isOn);
}

- (void)_applyThumbPosition:(BOOL)animated {
    for (NSLayoutConstraint *c in _toggleTrack.constraints) {
        if ((c.firstItem == _toggleThumb || c.secondItem == _toggleThumb)
            && c.firstAttribute == NSLayoutAttributeLeading) {
            [c setActive:NO];
        }
    }
    [[_toggleThumb.leadingAnchor constraintEqualToAnchor:_toggleTrack.leadingAnchor
                                                constant:_isOn ? 18 : 2] setActive:YES];
    if (animated) {
        [UIView animateWithDuration:0.18 animations:^{ [self->_toggleTrack layoutIfNeeded]; }];
    }
}
@end


@interface ZSliderRow : UIView
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *valueLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, copy)   void (^onChange)(float value);
- (instancetype)initWithTitle:(NSString *)title min:(float)min max:(float)max value:(float)val;
@end

@implementation ZSliderRow
- (instancetype)initWithTitle:(NSString *)title min:(float)min max:(float)max value:(float)val {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = COLOR_ROW;
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = title;
    _titleLabel.textColor = COLOR_TEXT;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];

    _valueLabel = [[UILabel alloc] init];
    _valueLabel.text = [NSString stringWithFormat:@"%.0f", val];
    _valueLabel.textColor = COLOR_ACCENT;
    _valueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_valueLabel];

    _slider = [[UISlider alloc] init];
    _slider.minimumValue = min;
    _slider.maximumValue = max;
    _slider.value = val;
    _slider.minimumTrackTintColor = COLOR_ACCENT;
    _slider.maximumTrackTintColor = [UIColor colorWithWhite:0.3 alpha:1.0];
 
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(22,22), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, COLOR_ACCENT.CGColor);
    CGContextFillEllipseInRect(ctx, CGRectMake(0,0,22,22));
    UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_slider setThumbImage:thumb forState:UIControlStateNormal];
    [_slider setThumbImage:thumb forState:UIControlStateHighlighted];
    _slider.translatesAutoresizingMaskIntoConstraints = NO;
    [_slider addTarget:self action:@selector(_changed) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];

    [NSLayoutConstraint activateConstraints:@[
        [_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14],
        [_valueLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [_valueLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14],
        [_slider.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:6],
        [_slider.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14],
        [_slider.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14],
        [_slider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
    ]];
    return self;
}
- (void)_changed {
    _valueLabel.text = [NSString stringWithFormat:@"%.0f", _slider.value];
    if (_onChange) _onChange(_slider.value);
}
@end


@interface ZSidebarButton : UIButton
@property (nonatomic, assign) MenuTab tab;
- (instancetype)initWithTab:(MenuTab)tab imageName:(NSString *)name;
- (void)setActive:(BOOL)active;
@end

@implementation ZSidebarButton
- (instancetype)initWithTab:(MenuTab)tab imageName:(NSString *)name {
    self = [super initWithFrame:CGRectMake(0, 0, 46, 46)];
    if (!self) return nil;
    _tab = tab;
    UIImage *img = ZSFImage(name, 18);
    [self setImage:img forState:UIControlStateNormal];
    self.tintColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    self.layer.cornerRadius = 12;
    return self;
}
- (void)setActive:(BOOL)active {
    [UIView animateWithDuration:0.18 animations:^{
        self.tintColor = active ? COLOR_ACCENT : [UIColor colorWithWhite:0.45 alpha:1.0];
        self.backgroundColor = active ? [COLOR_ACCENT colorWithAlphaComponent:0.15] : UIColor.clearColor;
    }];
}
@end


@interface monaMenu : NSObject
@property (nonatomic, strong) UIView       *menuView;
@property (nonatomic, strong) UIView       *sidebarView;
@property (nonatomic, strong) UIView       *panelView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *tabTitleLabel;
@property (nonatomic, strong) UIImageView  *tabIconView;
@property (nonatomic, assign) MenuTab       currentTab;
@property (nonatomic, strong) NSArray<ZSidebarButton *> *sidebarButtons;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint        lastPoint;
@end

@implementation BrazilixMenu

static monaMenu *extraInfo;
static BOOL MenDeal;
UIWindow *mainWindow;
game_sdk_t *game_sdk = new game_sdk_t();

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        mainWindow = [UIApplication sharedApplication].keyWindow;
        extraInfo = [BrazilixMenu new];
        static bool sdkInitialized = false;
        if (!sdkInitialized) { game_sdk->init(); sdkInitialized = true; }
        [extraInfo setupDisplayLink];
        [extraInfo initTapGes];
    });
}

- (void)setupDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMenu)];
    _displayLink.frameInterval = 2;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)setupMenu {
    CGFloat menuW = 560;
    CGFloat menuH = 420;
    CGFloat x = (kWidth  - menuW) * 0.5f;
    CGFloat y = (kHeight - menuH) * 0.5f;

    _menuView = [[UIView alloc] initWithFrame:CGRectMake(x, y, menuW, menuH)];
    _menuView.backgroundColor = UIColor.clearColor;
    _menuView.hidden = YES;
    _menuView.userInteractionEnabled = YES;
    [mainWindow addSubview:_menuView];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
        initWithTarget:self action:@selector(handlePan:)];
    [_menuView addGestureRecognizer:pan];


    CGFloat sideW = 64;
    _sidebarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sideW, menuH)];
    _sidebarView.backgroundColor = COLOR_SIDEBAR;
    _sidebarView.layer.cornerRadius = 16;
    _sidebarView.clipsToBounds = YES;
    [_menuView addSubview:_sidebarView];

    NSArray *icons = @[@"scope", @"eye", @"cube.box", @"gearshape", @"person"];
    NSMutableArray *btns = [NSMutableArray array];
    CGFloat iconY = 16;
    for (int i = 0; i < (int)icons.count; i++) {
        ZSidebarButton *btn = [[ZSidebarButton alloc] initWithTab:(MenuTab)i imageName:icons[i]];
        btn.frame = CGRectMake(9, iconY, 46, 46);
        [btn addTarget:self action:@selector(sidebarTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_sidebarView addSubview:btn];
        [btns addObject:btn];
        iconY += 52;
    }
    _sidebarButtons = [btns copy];
    [_sidebarButtons[0] setActive:YES];


    CGFloat panelW = menuW - sideW - 6;
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(sideW + 6, 0, panelW, menuH)];
    _panelView.backgroundColor = COLOR_PANEL;
    _panelView.layer.cornerRadius = 16;
    _panelView.clipsToBounds = YES;
    [_menuView addSubview:_panelView];

   
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelW, 52)];
    header.backgroundColor = UIColor.clearColor;
    [_panelView addSubview:header];

    
    UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(14, 12, 28, 28)];
    iconBg.backgroundColor = [COLOR_ACCENT colorWithAlphaComponent:0.2];
    iconBg.layer.cornerRadius = 8;
    [header addSubview:iconBg];

    _tabIconView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 14, 14)];
    _tabIconView.image = ZSFImage(@"cube.box", 14);
    _tabIconView.tintColor = COLOR_ACCENT;
    [iconBg addSubview:_tabIconView];

    _tabTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 200, 24)];
    _tabTitleLabel.text = @"AIMBOT";
    _tabTitleLabel.textColor = COLOR_TEXT;
    _tabTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [header addSubview:_tabTitleLabel];

  
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setImage:ZSFImage(@"xmark", 14) forState:UIControlStateNormal];
    closeBtn.tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    closeBtn.frame = CGRectMake(panelW - 44, 12, 28, 28);
    closeBtn.backgroundColor = [UIColor colorWithWhite:0.22 alpha:1.0];
    closeBtn.layer.cornerRadius = 8;
    [closeBtn addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];

   
    UIButton *moonBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moonBtn setImage:ZSFImage(@"moon", 14) forState:UIControlStateNormal];
    moonBtn.tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    moonBtn.frame = CGRectMake(panelW - 80, 12, 28, 28);
    moonBtn.backgroundColor = [UIColor colorWithWhite:0.22 alpha:1.0];
    moonBtn.layer.cornerRadius = 8;
    [header addSubview:moonBtn];

 
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 51, panelW, 0.5)];
    sep.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    [_panelView addSubview:sep];


    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 52, panelW, menuH - 52)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [_panelView addSubview:_scrollView];

    [self loadTab:MenuTabAimbot];
}


- (void)loadTab:(MenuTab)tab {
    _currentTab = tab;
    for (UIView *v in _scrollView.subviews) [v removeFromSuperview];

    CGFloat panelW = _panelView.bounds.size.width;
    CGFloat rowH = 52, gap = 8, px = 12;
    CGFloat rw = panelW - px * 2;
    CGFloat y  = 10;

    switch (tab) {

        case MenuTabAimbot: {
            _tabTitleLabel.text = @"AIMBOT";
            _tabIconView.image = ZSFImage(@"scope", 14);
            NSArray *rows = @[
                @[@"Aimbot",     @"Aimbot"],
                @[@"Silent Aim", @"SilentAim"],
                @[@"No Recoil",  @"NoRecoil"],
                @[@"Fast Fire",  @"FastFire"],
            ];
            for (NSArray *r in rows) {
                BOOL st = [[NSUserDefaults standardUserDefaults] boolForKey:r[1]];
                ZToggleRow *row = [[ZToggleRow alloc] initWithTitle:r[0] isOn:st];
                row.frame = CGRectMake(px, y, rw, rowH);
                NSString *key = r[1];
                row.onToggle = ^(BOOL on) {
                    [[NSUserDefaults standardUserDefaults] setBool:on forKey:key];
                    if ([key isEqualToString:@"Aimbot"]) Vars.Aimbot = on;
                };
                [_scrollView addSubview:row];
                y += rowH + gap;
            }
            ZSliderRow *fov = [[ZSliderRow alloc] initWithTitle:@"FOV Size" min:50 max:400 value:Vars.AimFov];
            fov.frame = CGRectMake(px, y, rw, 70);
            fov.onChange = ^(float v) { Vars.AimFov = v; };
            [_scrollView addSubview:fov];
            y += 70 + gap;
            break;
        }

        case MenuTabESP: {
            _tabTitleLabel.text = @"ESP";
            _tabIconView.image = ZSFImage(@"eye", 14);
            NSArray *rows = @[
                @[@"Enable ESP", @"Enable"],
                @[@"Box ESP",    @"Box"],
                @[@"Lines ESP",  @"Lines"],
                @[@"Names",      @"Name"],
                @[@"Health Bar", @"Health"],
                @[@"Distance",   @"Distance"],
                @[@"Skeleton",   @"Skeleton"],
            ];
            for (NSArray *r in rows) {
                BOOL st = [[NSUserDefaults standardUserDefaults] boolForKey:r[1]];
                ZToggleRow *row = [[ZToggleRow alloc] initWithTitle:r[0] isOn:st];
                row.frame = CGRectMake(px, y, rw, rowH);
                NSString *key = r[1];
                row.onToggle = ^(BOOL on) {
                    [[NSUserDefaults standardUserDefaults] setBool:on forKey:key];
                    if ([key isEqualToString:@"Enable"])   Vars.Enable   = on;
                    if ([key isEqualToString:@"Box"])      Vars.Box      = on;
                    if ([key isEqualToString:@"Name"])     Vars.Name     = on;
                    if ([key isEqualToString:@"Health"])   Vars.Health   = on;
                    if ([key isEqualToString:@"Distance"]) Vars.Distance = on;
                    if ([key isEqualToString:@"Skeleton"]) Vars.skeleton = on;
                };
                [_scrollView addSubview:row];
                y += rowH + gap;
            }
            break;
        }

        case MenuTabMisc: {
            _tabTitleLabel.text = @"MISC";
            _tabIconView.image = ZSFImage(@"cube.box", 14);

         
            UILabel *warn = [[UILabel alloc] initWithFrame:CGRectMake(px, y, rw, 56)];
            warn.numberOfLines = 0;
            NSMutableAttributedString *ws = [[NSMutableAttributedString alloc] init];
            NSDictionary *normal = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.75 alpha:1.0], NSFontAttributeName: [UIFont systemFontOfSize:12]};
            NSDictionary *accent = @{NSForegroundColorAttributeName: COLOR_ACCENT, NSFontAttributeName: [UIFont systemFontOfSize:12]};
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@"Some options in this section may " attributes:normal]];
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@"not be entirely safe" attributes:accent]];
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@".\nUse with " attributes:normal]];
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@"caution" attributes:accent]];
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@" and at " attributes:normal]];
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@"your own risk" attributes:accent]];
            [ws appendAttributedString:[[NSAttributedString alloc] initWithString:@"." attributes:normal]];
            warn.attributedText = ws;
            warn.backgroundColor = [UIColor colorWithWhite:0.18 alpha:1.0];
            warn.layer.cornerRadius = 10;
            warn.clipsToBounds = YES;
        
            UIView *warnPad = [[UIView alloc] initWithFrame:CGRectMake(px, y, rw, 56)];
            warnPad.backgroundColor = [UIColor colorWithWhite:0.18 alpha:1.0];
            warnPad.layer.cornerRadius = 10;
            warnPad.clipsToBounds = YES;
            warn.frame = CGRectMake(12, 8, rw - 24, 40);
            [warnPad addSubview:warn];
            [_scrollView addSubview:warnPad];
            y += 56 + gap;

            NSArray *rows = @[
                @[@"No Recoil",        @"NoRecoil"],
                @[@"Fast Swap Weapon", @"FastSwap"],
                @[@"Fast Reload",      @"FastReload"],
                @[@"Fast Parachute",   @"FastParachute"],
                @[@"Teleport (8m)",    @"Teleport"],
                @[@"Screen Stretch",   @"ScreenStretch"],
                @[@"Force 120 FPS",    @"Force120FPS"],
                @[@"Spin Player",      @"SpinPlayer"],
            ];
            for (NSArray *r in rows) {
                BOOL st = [[NSUserDefaults standardUserDefaults] boolForKey:r[1]];
                ZToggleRow *row = [[ZToggleRow alloc] initWithTitle:r[0] isOn:st];
                row.frame = CGRectMake(px, y, rw, rowH);
                NSString *key = r[1];
                row.onToggle = ^(BOOL on) {
                    [[NSUserDefaults standardUserDefaults] setBool:on forKey:key];
                };
                [_scrollView addSubview:row];
                y += rowH + gap;
            }
            ZSliderRow *spin = [[ZSliderRow alloc] initWithTitle:@"Spin Speed" min:10 max:360 value:180];
            spin.frame = CGRectMake(px, y, rw, 70);
            [_scrollView addSubview:spin];
            y += 70 + gap;
            break;
        }

        case MenuTabSettings: {
            _tabTitleLabel.text = @"SETTINGS";
            _tabIconView.image = ZSFImage(@"gearshape", 14);
            NSArray *rows = @[
                @[@"Anti Screenshot", @"AntiSS"],
                @[@"Stealth Mode",    @"Stealth"],
            ];
            for (NSArray *r in rows) {
                BOOL st = [[NSUserDefaults standardUserDefaults] boolForKey:r[1]];
                ZToggleRow *row = [[ZToggleRow alloc] initWithTitle:r[0] isOn:st];
                row.frame = CGRectMake(px, y, rw, rowH);
                NSString *key = r[1];
                row.onToggle = ^(BOOL on) {
                    [[NSUserDefaults standardUserDefaults] setBool:on forKey:key];
                };
                [_scrollView addSubview:row];
                y += rowH + gap;
            }
            break;
        }

        case MenuTabProfile: {
            _tabTitleLabel.text = @"PROFILE";
            _tabIconView.image = ZSFImage(@"person", 14);
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(px, y, rw, 40)];
            name.text = @"MONA X YUE ENN";
            name.textColor = COLOR_ACCENT;
            name.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
            name.textAlignment = NSTextAlignmentCenter;
            [_scrollView addSubview:name];
            y += 44;
            UILabel *ver = [[UILabel alloc] initWithFrame:CGRectMake(px, y, rw, 24)];
            ver.text = @"PROJECT FREE";
            ver.textColor = COLOR_SUBTEXT;
            ver.font = [UIFont systemFontOfSize:12];
            ver.textAlignment = NSTextAlignmentCenter;
            [_scrollView addSubview:ver];
            y += 28;
            break;
        }
    }

    _scrollView.contentSize = CGSizeMake(_panelView.bounds.size.width, y + 16);
}


- (void)sidebarTapped:(ZSidebarButton *)btn {
    for (ZSidebarButton *b in _sidebarButtons) [b setActive:NO];
    [btn setActive:YES];
    [self loadTab:btn.tab];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint t = [pan translationInView:mainWindow];
    if (pan.state == UIGestureRecognizerStateBegan) _lastPoint = _menuView.center;
    _menuView.center = CGPointMake(_lastPoint.x + t.x, _lastPoint.y + t.y);
}

- (void)updateMenu {
    _menuView.hidden = !MenDeal;
    get_players();
}

- (void)closeMenu { MenDeal = false; }

- (void)initTapGes {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(openMenu)];
    tap1.numberOfTapsRequired = 2; tap1.numberOfTouchesRequired = 3;
    [mainWindow addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(closeMenu)];
    tap2.numberOfTapsRequired = 2; tap2.numberOfTouchesRequired = 2;
    [mainWindow addGestureRecognizer:tap2];
}

- (void)openMenu {
    if (!_menuView) [self setupMenu];
    MenDeal = true;
}

@end


void game_sdk_t::init() {
    this->GetHp = (int (*)(void *))getRealOffset(0x4A8478C);
    this->Curent_Match = (void *(*)())getRealOffset(0x4E355B0);
    this->GetLocalPlayer = (void *(*)(void *))getRealOffset(0x28FC854);
    this->GetHeadPositions = (void *(*)(void *))getRealOffset(0x4AA1A28);
    this->get_position = (Vector3(*)(void *))getRealOffset(0x8552BAC);
    this->Component_GetTransform = (void *(*)(void *))getRealOffset(0x854060C);
    this->get_camera = (void *(*)())getRealOffset(0x84E7148);
    this->WorldToScreenPoint = (Vector3(*)(void *, Vector3))getRealOffset(0x84E6AC8);
    this->WorldToScreenPointEx = (Vector3(*)(void *, Vector3, int))getRealOffset(0x84E6AC8);
    this->get_isVisible = (bool (*)(void *))getRealOffset(0x4A20AF4);
    this->get_isLocalTeam = (bool (*)(void *))getRealOffset(0x4A38D90);
    this->get_IsDieing = (bool (*)(void *))getRealOffset(0x4A02EA8);
    this->get_MaxHP = (int (*)(void *))getRealOffset(0x4A8489C);
    this->GetForward = (Vector3(*)(void *))getRealOffset(0x85534CC);
    this->set_aim = (void (*)(void *, Quaternion))getRealOffset(0x4A1C91C);
    this->get_IsSighting = (bool (*)(void *))getRealOffset(0x4A0FF18);
    this->get_IsFiring = (bool (*)(void *))getRealOffset(0x4A05634);
    this->name = (monoString * (*)(void *player))getRealOffset(0x4A16D38);
    this->_GetHeadPositions = (void *(*)(void *))getRealOffset(0x4AA1A28);
    this->_newHipMods = (void *(*)(void *))getRealOffset(0x4AA1BD8);
    this->_GetLeftAnkleTF = (void *(*)(void *))getRealOffset(0x4AA2028);
    this->_GetRightAnkleTF = (void *(*)(void *))getRealOffset(0x4AA2134);
    this->_GetLeftToeTF = (void *(*)(void *))getRealOffset(0x4AA2240);
    this->_GetRightToeTF = (void *(*)(void *))getRealOffset(0x4AA234C);
    this->_getLeftHandTF = (void *(*)(void *))getRealOffset(0x4A1B9B4);
    this->_getRightHandTF = (void *(*)(void *))getRealOffset(0x4A1BAB8);
    this->_getLeftForeArmTF = (void *(*)(void *))getRealOffset(0x4A1BBBC);
    this->_getRightForeArmTF = (void *(*)(void *))getRealOffset(0x4A1BCC0);
}
