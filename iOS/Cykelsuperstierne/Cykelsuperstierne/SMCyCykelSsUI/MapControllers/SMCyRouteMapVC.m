//
//  SMCyRouteMap.m
//  Cykelsuperstierne
//
//  Created by Rasko Gojkovic on 7/1/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyRouteMapVC.h"
#import "SMCyUser.h"
#import "SMCyTripRoute.h"
#import <RMAnnotation.h>
#import <RMMarker.h>
#import <RMShape.h>
#import "SMCyBreakRouteVC.h"
/* *** Map Constants *** */
#define PATH_OPACITY 0.8
#define PATH_COLOR [UIColor orangeColor]
#define LINE_WIDTH 10.0
// annotation keys
#define aKeyMarker @"marker"
#define aKeyPath @"path"
#define aKeyLine @"line"
#define aKeyWaypoints @"waypoints"
#define aKeyLineColor @"lineColor"
#define aKeyLineWidth @"lineWidth"
#define aKeyFillColor @"fillColor"
#define aKeyLineStart @"lineStart"
#define aKeyLineEnd   @"lineEnd"
#define aKeyClosePath @"closePath"
/* *** ************* *** */



@interface SMCyRouteMapVC ()
@property(nonatomic, strong) SMCyTripRoute* currentRoute;
@end

@implementation SMCyRouteMapVC

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
	// Do any additional setup after loading the view.
    
    // get user current route
    // TODO: Handle invalid route
    SMCyRoute* route= [SMCyUser activeUser].activeRoute;
    self.currentRoute= (SMCyTripRoute*)route;
    
    NSLog(@"Start coordinate %lf %lf",self.currentRoute.start.location2DCoord.latitude, self.currentRoute.start.location2DCoord.longitude );
    NSLog(@"End coordinate %lf %lf",self.currentRoute.end.location2DCoord.latitude, self.currentRoute.end.location2DCoord.longitude );
    
    RMAnnotation* startAnnotation= [RMAnnotation annotationWithMapView:self.mapView coordinate:self.currentRoute.start.location2DCoord andTitle:@"A"];
    startAnnotation.annotationType = aKeyMarker;
    startAnnotation.annotationIcon = [UIImage imageNamed:@"marker-red"];
    startAnnotation.anchorPoint = CGPointMake(0.5, 1.0);
    startAnnotation.enabled= YES;
    
    RMAnnotation* endAnnotation= [RMAnnotation annotationWithMapView:self.mapView coordinate:self.currentRoute.end.location2DCoord andTitle:@"B"];
    endAnnotation.annotationType= aKeyMarker;
    endAnnotation.annotationIcon= [UIImage imageNamed:@"marker-red"];
    endAnnotation.anchorPoint= CGPointMake(0.5, 1.0);
    endAnnotation.enabled= YES;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:endAnnotation];

    [self displayRoutePath];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mapView setCenterCoordinate:self.currentRoute.start.location2DCoord];
    [self.mapView setUserTrackingMode:RMUserTrackingModeNone];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"pushing %@", NSStringFromClass([segue.destinationViewController class]));
}

- (IBAction)onBreakRoute:(id)sender {
    self.currentRoute.delegate= self;

    BOOL canBreakRoute= [self.currentRoute breakRoute];
    //TODO: do something with the result, Rasko...

}

- (IBAction)onClose:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayRoutePath {
    [self removePathsFromMapView:self.mapView];

    // each route has two waypoints, but the Nth ending is the Nth+1 beginning, so we have n+1 waypoints in total
    NSMutableArray* pathWaypoints = [NSMutableArray new];

    for (int i=0; i<self.currentRoute.routes.count; i++){
        SMCyBikeRoute * route= [self.currentRoute.routes objectAtIndex:i];
        
        for( int j=0; j<route.waypoints.count; j++){
            if(j==0 && i!=0)
                continue;

            [pathWaypoints addObject:[route.waypoints objectAtIndex:j]];
        }

        [pathWaypoints addObject:route.end];
    }
    
    SMCyLocation* loc = nil;
    if (pathWaypoints && [pathWaypoints count] > 0) {
        loc = [pathWaypoints objectAtIndex:0];
    }
    
    RMAnnotation *pathAnnotation = [RMAnnotation annotationWithMapView:self.mapView coordinate:loc.location2DCoord andTitle:nil];
    pathAnnotation.annotationType = aKeyPath;
    pathAnnotation.userInfo = @{
                                aKeyWaypoints : [NSArray arrayWithArray:pathWaypoints],
                                aKeyLineColor : PATH_COLOR,
                                aKeyFillColor : [UIColor clearColor],
                                aKeyLineWidth : [NSNumber numberWithFloat:LINE_WIDTH],
                               };
    [pathAnnotation setBoundingBoxFromLocations:[pathWaypoints valueForKey:@"location"]];
    [self.mapView addAnnotation:pathAnnotation];
}

-(void)removePathsFromMapView:(RMMapView*)mapView{
    [self removeAnnotationsFromMapView:mapView named:aKeyPath];
}

-(void)removeAnnotationsFromMapView:(RMMapView*)mapView named:(NSString*)typeName{
    for (RMAnnotation *annotation in mapView.annotations) {
        if ([annotation.annotationType isEqualToString:typeName]) {
            [mapView removeAnnotation:annotation];
        }
    }
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
    if ([annotation.annotationType isEqualToString:aKeyPath]) {
        //        RMPath * path = [[RMPath alloc] initWithView:aMapView];
        RMShape *path = [[RMShape alloc] initWithView:mapView];
        [path setZPosition:-MAXFLOAT];
        [path setLineColor:[annotation.userInfo objectForKey:aKeyLineColor]];
        [path setOpacity:PATH_OPACITY];
        [path setFillColor:[annotation.userInfo objectForKey:aKeyFillColor]];
        [path setLineWidth:[[annotation.userInfo objectForKey:aKeyLineWidth] floatValue]];
        path.scaleLineWidth = NO;
        
        if ([[annotation.userInfo objectForKey:aKeyClosePath] boolValue])
            [path closePath];
        
        @synchronized([annotation.userInfo objectForKey:aKeyWaypoints]) {
            for (SMCyLocation *location in [annotation.userInfo objectForKey:aKeyWaypoints]) {
                [path addLineToCoordinate:location.location2DCoord];
            }
        }
        
        return path;
    }
    
    if ([annotation.annotationType isEqualToString:aKeyLine]) {
        RMShape *line = [[RMShape alloc] initWithView:mapView];
        [line setZPosition:-MAXFLOAT];
        [line setLineColor:[annotation.userInfo objectForKey:aKeyLineColor]];
        [line setOpacity:PATH_OPACITY];
        [line setFillColor:[annotation.userInfo objectForKey:aKeyFillColor]];
        [line setLineWidth:[[annotation.userInfo objectForKey:aKeyLineWidth] floatValue]];
        line.scaleLineWidth = YES;
        
        CLLocation *start = [annotation.userInfo objectForKey:aKeyLineStart];
        [line addLineToCoordinate:start.coordinate];
        CLLocation *end = [annotation.userInfo objectForKey:aKeyLineEnd];
        [line addLineToCoordinate:end.coordinate];
        
        return line;
    }

    if ([annotation.annotationType isEqualToString:aKeyMarker]) {
        RMMarker * rm = [[RMMarker alloc] initWithUIImage:annotation.annotationIcon anchorPoint:annotation.anchorPoint];
        [rm setZPosition:100];
        return rm;
    }
    
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

#pragma mark - SMCyRouteDelegate

-(void)routeStateChanged:(SMCyRoute*)route{
    if(route.state == RS_READY)
        [self performSegueWithIdentifier:@"routeMapToBreakRoute" sender:self];
}

@end
