// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI31_0_0EXFileSystem/ABI31_0_0EXFileSystemManagerService.h>
#import <ABI31_0_0EXCore/ABI31_0_0EXDefines.h>

// TODO @sjchmiela: Should this be versioned? It is only used in detached scenario.
NSString * const ABI31_0_0EXShellManifestResourceName = @"shell-app-manifest";

@implementation ABI31_0_0EXFileSystemManagerService

ABI31_0_0EX_REGISTER_MODULE()

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI31_0_0EXFileSystemManager)];
}

- (NSString *)bundleDirectoryForExperienceId:(NSString *)experienceId
{
  return [NSBundle mainBundle].bundlePath;
}

- (NSArray<NSString *> *)bundledAssetsForExperienceId:(NSString *)experienceId
{
  static NSArray<NSString *> *bundledAssets = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    NSString *manifestBundlePath = [[NSBundle mainBundle] pathForResource:ABI31_0_0EXShellManifestResourceName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:manifestBundlePath];
    if (data.length == 0) {
      return;
    }
    __block NSError *error;
    id manifest = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
      ABI31_0_0EXLogError(@"Error parsing bundled manifest: %@", error);
      return;
    }
    bundledAssets = manifest[@"bundledAssets"];
  });
  return bundledAssets;
}

@end

