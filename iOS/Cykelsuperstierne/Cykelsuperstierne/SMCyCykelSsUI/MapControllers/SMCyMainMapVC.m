//
//  SMCyMainMapVC.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyMainMapVC.h"
#import "SMCyMainMapVC+Animations.h"
#import <QuartzCore/QuartzCore.h>
#import "SMrUtil.h"
#import "SMCyMenuController.h"
#import "SMiBikeCPHMapTileSource.h"
#import "RMOpenStreetMapSource.h"

#define DEFAULT_LOCATION CLLocationCoordinate2DMake(55.675455,12.566643)

@interface SMCyMainMapVC ()

@end

@implementation SMCyMainMapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"SMCyMenu" sender:self];
    [self initializeOpenCloseStates];
    [self.mapView setTileSource:TILE_SOURCE];
    [self.mapView setDelegate:self];
    [self.mapView setMaxZoom:20.0];
    
    [self.mapView setCenterCoordinate:DEFAULT_LOCATION animated:NO];
    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
    self.mapView.triggerUpdateOnHeadingChange = YES;
    self.mapView.displayHeadingCalibration = NO;
    self.mapView.enableBouncing = NO;
    
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
    UIViewController * addedVC = childController;
    if([addedVC isKindOfClass:[UINavigationController class]]){
        addedVC = [addedVC.childViewControllers objectAtIndex:0];
    }
    if([addedVC isKindOfClass:[SMCyMenuController class]]){
        _menuVC = (SMCyMenuController*)addedVC;
        _menuVC.delegate = self;
    }
}


- (IBAction)onSearchLocation:(UIButton *)sender {
    [self performSegueWithIdentifier:@"mainMapToRouteSetter" sender:self];    
}

- (IBAction)onChangeOrientation:(UIButton *)sender {

}

#pragma mark - menu delegate methods

-(void)mapMenuSelectionChanged:(SMCyMenu*)menu{
    
}

-(void)userMenuDidAddNewFavorite:(SMCyMenu*)menu{
    
}

-(void)userMenuProfileClicked:(SMCyMenu*)menu{
    
}

-(void)userMenuAboutClicked:(SMCyMenu*)menu{
    
}

#pragma mark - RMMap delegate methods


/** @name Working With Annotation Layers */

/** Returns (after creating or reusing) the layer associated with the specified annotation object.
 *
 *   An annotation layer can be created using RMMapLayer and its subclasses, such as RMMarker for points and RMShape for shapes such as lines and polygons.
 *
 *   If you do not implement this method, or if you return `nil` from your implementation for annotations other than the user location annotation, the map view does not display a layer for the annotation.
 *
 *   @param mapView The map view that requested the annotation layer.
 *   @param annotation The object representing the annotation that is about to be displayed. In addition to your custom annotations, this object could be an RMUserLocation object representing the user’s current location.
 *   @return The annotation layer to display for the specified annotation or `nil` if you do not want to display a layer. */
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    return nil;
}

/** Tells the delegate that the visible layer for an annotation is about to be hidden from view due to scrolling or zooming the map.
 *   @param mapView The map view whose annotation alyer will be hidden.
 *   @param annotation The annotation whose layer will be hidden. */
- (void)mapView:(RMMapView *)mapView willHideLayerForAnnotation:(RMAnnotation *)annotation{
    
}

/** Tells the delegate that the visible layer for an annotation has been hidden from view due to scrolling or zooming the map.
 *   @param mapView The map view whose annotation layer was hidden.
 *   @param annotation The annotation whose layer was hidden. */
- (void)mapView:(RMMapView *)mapView didHideLayerForAnnotation:(RMAnnotation *)annotation{
    
}

/** @name Responding to Map Position Changes */

/** Tells the delegate when a map is about to move.
 *   @param map The map view that is about to move.
 *   @param wasUserAction A Boolean indicating whether the map move is in response to a user action or not. */
- (void)beforeMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction{
    
}

/** Tells the delegate when a map has finished moving.
 *   @param map The map view that has finished moving.
 *   @param wasUserAction A Boolean indicating whether the map move was in response to a user action or not. */
- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction{
    
}

/** Tells the delegate when a map is about to zoom.
 *   @param map The map view that is about to zoom.
 *   @param wasUserAction A Boolean indicating whether the map zoom is in response to a user action or not. */
- (void)beforeMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction{
    
}

/** Tells the delegate when a map has finished zooming.
 *   @param map The map view that has finished zooming.
 *   @param wasUserAction A Boolean indicating whether the map zoom was in response to a user action or not. */
- (void)afterMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction{
    
}

/** Tells the delegate that the region displayed by the map view just changed.
 *
 *   This method is called whenever the currently displayed map region changes. During scrolling, this method may be called many times to report updates to the map position. Therefore, your implementation of this method should be as lightweight as possible to avoid affecting scrolling performance.
 *   @param mapView The map view whose visible region changed. */
- (void)mapViewRegionDidChange:(RMMapView *)mapView{
    
}

/** @name Responding to Map Gestures */

/** Tells the delegate when the user double-taps a map view.
 *   @param map The map that was double-tapped.
 *   @param point The point at which the map was double-tapped. */
- (void)doubleTapOnMap:(RMMapView *)map at:(CGPoint)point{
    
}

/** Tells the delegate when the user taps a map view.
 *   @param map The map that was tapped.
 *   @param point The point at which the map was tapped. */
- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point{
    
}

/** Tells the delegate when the user taps a map view with two fingers.
 *   @param map The map that was tapped.
 *   @param point The center point at which the map was tapped. */
- (void)singleTapTwoFingersOnMap:(RMMapView *)map at:(CGPoint)point{
    
}

/** Tells the delegate when the user long-presses a map view.
 *   @param map The map that was long-pressed.
 *   @param point The point at which the map was long-pressed. */
- (void)longSingleTapOnMap:(RMMapView *)map at:(CGPoint)point{
    
}

/** @name Responding to User Annotation Gestures */

/** Tells the delegate when the user taps the layer for an annotation.
 *   @param annotation The annotation that was tapped.
 *   @param map The map view. */
- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    
}

/** Tells the delegate when the user double-taps the layer for an annotation.
 *   @param annotation The annotation that was double-tapped.
 *   @param map The map view. */
- (void)doubleTapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    
}

/** Tells the delegate when the user taps the label for an annotation.
 *   @param annotation The annotation whose label was was tapped.
 *   @param map The map view. */
- (void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    
}

/** Tells the delegate when the user double-taps the label for an annotation.
 *   @param annotation The annotation whose label was was double-tapped.
 *   @param map The map view. */
- (void)doubleTapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    
}

/** Asks the delegate whether the user should be allowed to drag the layer for an annotation.
 *   @param map The map view.
 *   @param annotation The annotation the user is attempting to drag.
 *   @return A Boolean value indicating whether the user should be allowed to drag the annotation layer. */
- (BOOL)mapView:(RMMapView *)map shouldDragAnnotation:(RMAnnotation *)annotation{
    return NO;
}

/** Tells the delegate that the user is dragging an annotation layer.
 *
 *   If the screen location of the annotation layer should be changed, you are responsible for adjusting it.
 *   @param map The map view.
 *   @param annotation The annotation being dragged.
 *   @param delta The delta of movement since the last drag notification. */
- (void)mapView:(RMMapView *)map didDragAnnotation:(RMAnnotation *)annotation withDelta:(CGPoint)delta{
    
}

/** Tells the delegate that the user has finished dragging an annotation layer.
 *
 *   If the screen position of the annotation layer has been changed since the drag operation started, you should update its coordinate to the final location in order to ensure that the annotation is displayed there going forward. Otherwise, the next time the annotations are adjusted, it will revert to its original position from before the drag.
 *   @param map The map view.
 *   @param annotation The annotation that was dragged. */
- (void)mapView:(RMMapView *)map didEndDragAnnotation:(RMAnnotation *)annotation{
    
}

/** @name Tracking the User Location */

/** Tells the delegate that the map view will start tracking the user’s position.
 *
 *   This method is called when the value of the showsUserLocation property changes to YES.
 *   @param mapView The map view that is tracking the user’s location. */
- (void)mapViewWillStartLocatingUser:(RMMapView *)mapView{
    
}

/** Tells the delegate that the map view stopped tracking the user’s location.
 *
 *   This method is called when the value of the showsUserLocation property changes to NO.
 *   @param mapView The map view that stopped tracking the user’s location. */
- (void)mapViewDidStopLocatingUser:(RMMapView *)mapView{
    
}

/** Tells the delegate that the location of the user was updated.
 *
 *   While the showsUserLocation property is set to YES, this method is called whenever a new location update is received by the map view. This method is also called if the map view’s user tracking mode is set to RMUserTrackingModeFollowWithHeading and the heading changes.
 *
 *   This method is not called if the application is currently running in the background. If you want to receive location updates while running in the background, you must use the Core Location framework.
 *   @param mapView The map view that is tracking the user’s location.
 *   @param userLocation The location object representing the user’s latest location. */
- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation{
    
}

/** Tells the delegate that an attempt to locate the user’s position failed.
 *   @param mapView The map view that is tracking the user’s location.
 *   @param error An error object containing the reason why location tracking failed. */
- (void)mapView:(RMMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
}

/** Tells the delegate that the user tracking mode changed.
 *   @param mapView The map view whose user tracking mode changed.
 *   @param mode The mode used to track the user’s location.
 *   @param animated If YES, the change from the current mode to the new mode is animated; otherwise, it is not. This parameter affects only tracking mode changes. Changes to the user location or heading are always animated. */
- (void)mapView:(RMMapView *)mapView didChangeUserTrackingMode:(RMUserTrackingMode)mode animated:(BOOL)animated{
    
}




#pragma mark -

@end
