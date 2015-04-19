# WPPlayImageView
图片轮播框架，折叠效果、滑动效果，通过约束实现(非UIscrollView实现)

## 使用指南
1. 导入 `WPPlayImageView.h` 文件 

  ```objective-c
  #import "WPPlayImageView.h"
  ```
  
2. 通过 `playImageViewType:` 方法创建 View，并设置相应属性即可

  ```objective-c
  // 创建 View，并制定类型
  WPPlayImageView *v = [WPPlayImageView playImageViewType:self.model.type];
  // 轮播方向
  v.direction = self.model.direction;
  // 添加图片、对应图片的标题、点击回调
  v addImage:@"01" title:@"我是第01张图片" touchCallBack:^{
      NSLog(@"点击了第01张图片");
  }];
  // 设置 frame，并添加到父视图
  v.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 250);
  [self.view addSubview:v];
  ```

>如您有更好的建议，请邮件发至 704643349@qq.com，如您在使用中发现 bug，还请包涵、指正
