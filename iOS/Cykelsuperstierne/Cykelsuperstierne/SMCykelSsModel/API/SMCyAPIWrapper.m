//
//  SMCykelAPIWrapper.m
//  testAPIRequests
//
//  Created by Rasko Gojkovic on 6/21/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyAPIWrapper.h"
#import "SMrRequest.h"
#import "SMCyAPIVocabular.h"
#import "SMCyUser+APIInterface.h"

//"account_source" = ibikecph;
//"fb_token" = CAAGy4AwbHZBABAFZAUjrc5fnsnCnpwjRmFjL16sTs4iqczPKms9dHokHny9yCnVcXvrk0eZCeQilbxHAv7BxZCNY75QrCwxoI7NQvZAXJhO9m94ono0avwHmAtVIJMAGKSpF4R0GJUd19v9yEBDojVtKphKZAuj4aBgHUalxCzPgZDZD;


//#define API_ADDRESS @"ibikecph-staging.herokuapp.com"
//#define API_SERVER @"http://ibikecph-staging.herokuapp.com/api"
//#define API_DEFAULT_ACCEPT @{@"key": @"Accept", @"value" : @"application/vnd.ibikecph.v1"}
//#define API_DEFAULT_HEADERS @[API_DEFAULT_ACCEPT, @{@"key": @"Content-Type", @"value" : @"application/json"}]
//
//#define API_LOGIN @{@"service" : @"login", @"transferMethod" : @"POST", @"headers" : API_DEFAULT_HEADERS}
//#define API_REGISTER @{@"service" : @"users", @"transferMethod" : @"POST",  @"headers" : API_DEFAULT_HEADERS}
//#define API_GET_USER_DATA @{@"service" : @"users", @"transferMethod" : @"GET",  @"headers" : API_DEFAULT_HEADERS}
//#define API_CHANGE_USER_DATA @{@"service" : @"users", @"transferMethod" : @"PUT",  @"headers" : API_DEFAULT_HEADERS}
//#define API_CHANGE_PASSWORD @{@"service" : @"users/password", @"transferMethod" : @"PUT",  @"headers" : API_DEFAULT_HEADERS}
//#define API_DELETE_USER_DATA @{@"service" : @"users", @"transferMethod" : @"DELETE",  @"headers" : API_DEFAULT_HEADERS}
//
//#define API_SEND_FEEDBACK @{@"service" : @"issues", @"transferMethod" : @"POST",  @"headers" : API_DEFAULT_HEADERS}
//
//#define API_ADD_FAVORITE @{@"service" : @"favourites", @"transferMethod" : @"POST",  @"headers" : API_DEFAULT_HEADERS}
//#define API_EDIT_FAVORITE @{@"service" : @"favourites", @"transferMethod" : @"PUT",  @"headers" : API_DEFAULT_HEADERS}
//#define API_DELETE_FAVORITE @{@"service" : @"favourites", @"transferMethod" : @"DELETE",  @"headers" : API_DEFAULT_HEADERS}
//#define API_LIST_FAVORITES @{@"service" : @"favourites", @"transferMethod" : @"GET",  @"headers" : API_DEFAULT_HEADERS}
//
//#define API_LIST_HISTORY @{@"service" : @"routes", @"transferMethod" : @"GET",  @"headers" : API_DEFAULT_HEADERS}
//#define API_ADD_HISTORY @{@"service" : @"routes", @"transferMethod" : @"POST",  @"headers" : API_DEFAULT_HEADERS}
//
//#define API_SORT_FAVORITES @{@"service" : @"favourites/reorder", @"transferMethod" : @"POST",  @"headers" : API_DEFAULT_HEADERS}



//if (self.profileImage) {
//    [[params objectForKey:@"user"] setValue:@{
//     @"file" : [UIImageJPEGRepresentation(self.profileImage, 1.0f) base64EncodedString],
//     @"original_filename" : @"image.jpg",
//     @"filename" : @"image.jpg"
//     } forKey:@"image_path"];
//}


//#define API_SERVER @"ibikecph-staging.herokuapp.com"
//#define API_BASE_SERVICE @"api"
//#define API_DEFAULT_HEADERS  @{@"Accept": @"application/vnd.ibikecph.v1", @"Content-Type":@"application/json"}


@interface SMCyResponseData : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * errors;
@property (nonatomic, strong) NSDictionary * data;

+(SMCyResponseData*) createFromReceivedData:(NSData*)receivedData;

@end


@interface SMCyAPIWrapper()


@end

@implementation SMCyAPIWrapper


#pragma mark - user stuff

-(BOOL) loginUser:(SMCyUser*)user{
    SMrRequest * request = [self createRequestForCykelAPIWithService:API_SERVICE_LOGIN];
    NSDictionary * data = [user getLoginDictionary];
    request.httpMethod = @"POST";
    if(data){
        [request createPostDataFromJSONDict:data];
    }
    [request requestWithCompletion:^(SMrRequest* req){

        if(req.requestError.errorType == ET_FAILED){
            [user onLoginUserWithSuccess:NO Info:nil Errors:@"request failed" AndData:req.requestError.errorData];
            return;
        }
        
        SMCyResponseData * response = [SMCyResponseData createFromReceivedData:req.receivedData];
        
        [user onLoginUserWithSuccess:response.success Info:response.info Errors:response.errors AndData:response.data];

    }];
    
    return YES;
}

-(BOOL) deleteUser:(SMCyUser*)user{
    SMrRequest * request = [self createRequestForCykelAPIWithService:API_SERVICE_USERS];
    NSDictionary * data = [user getLoggedUserDictionary];
    request.httpMethod = @"DELETE";
    if(data){
        [request createPostDataFromJSONDict:data];
    } else {
        return NO;
    }
    [request requestWithCompletion:^(SMrRequest* req){
        
        if(req.requestError.errorType == ET_FAILED){
            [user onLoginUserWithSuccess:NO Info:nil Errors:@"request failed" AndData:req.requestError.errorData];
            return;
        }
        
        SMCyResponseData * response = [SMCyResponseData createFromReceivedData:req.receivedData];
        
        [user onDeleteUserWithSuccess:response.success Info:response.info Errors:response.errors AndData:response.data];
        
    }];
    
    return YES;
}

-(BOOL) getUser:(SMCyUser*)user{
    SMrRequest * request = [self createRequestForCykelAPIWithUserService:user];
    NSDictionary * data = [user getLoggedUserDictionary];
    
    request.httpMethod = @"GET";
    if(data){
        [request setArguments:[data mutableCopy]];
    } else {
        return NO;
    }
    [request requestWithCompletion:^(SMrRequest* req){
        
        if(req.requestError.errorType == ET_FAILED){
            [user onLoginUserWithSuccess:NO Info:nil Errors:@"request failed" AndData:req.requestError.errorData];
            return;
        }
        
        SMCyResponseData * response = [SMCyResponseData createFromReceivedData:req.receivedData];
        
        [user onGetUserDataWithSuccess:response.success Info:response.info Errors:response.errors AndData:response.data];
        
    }];
    return YES;
}

-(BOOL) changeUserData:(SMCyUser*)user{
    SMrRequest * request = [self createRequestForCykelAPIWithService:API_SERVICE_USERS];
    NSDictionary * data = [user getUpdateUserDictionary];
    request.httpMethod = @"PUT";
    if(data){
        [request createPostDataFromJSONDict:data];
    }
    [request requestWithCompletion:^(SMrRequest* req){
        
        if(req.requestError.errorType == ET_FAILED){
            [user onLoginUserWithSuccess:NO Info:nil Errors:@"request failed" AndData:req.requestError.errorData];
            return;
        }
        
        SMCyResponseData * response = [SMCyResponseData createFromReceivedData:req.receivedData];
        
        [user onChangeUserDataWithSuccess:response.success Info:response.info Errors:response.errors AndData:response.data];
        
    }];
    return YES;
}

#pragma mark - private utility methods
-(SMrRequest*)createRequestForCykelAPIWithService:(NSString*)serviceStr{
    SMrRequest * ret = [[SMrRequest alloc] initWithMainUrl:[API_SERVER copy] andService:[API_BASE_SERVICE stringByAppendingPathComponent:serviceStr]];
    for(NSString * key in API_DEFAULT_HEADERS.allKeys){
        [ret addHeaderValue:[API_DEFAULT_HEADERS valueForKey:key] forField:key];
    }
    return ret;
}

-(SMrRequest*)createRequestForCykelAPIWithUserService:(SMCyUser*)user{
    NSString * userService = [API_SERVICE_USERS stringByAppendingPathComponent:user.user_id];
    SMrRequest * ret = [[SMrRequest alloc] initWithMainUrl:[API_SERVER copy] andService:[API_BASE_SERVICE stringByAppendingPathComponent:userService]];
    for(NSString * key in API_DEFAULT_HEADERS.allKeys){
        [ret addHeaderValue:[API_DEFAULT_HEADERS valueForKey:key] forField:key];
    }
    return ret;
}

#pragma mark - static
+(SMCyAPIWrapper*) sharedInstance{
    static SMCyAPIWrapper * sharedInstance = nil;
    
    if(!sharedInstance){
        sharedInstance = [SMCyAPIWrapper new];
    }
    
    return sharedInstance;
}
@end

#pragma mark - SMCyResponseData implementation
@implementation SMCyResponseData

+(SMCyResponseData*) createFromReceivedData:(NSData*)receivedData{
    SMCyResponseData * ret = nil;
    if(receivedData){
        NSError * err;
        NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&err];
        if(!dict) return nil;
        
        ret = [SMCyResponseData new];
        ret.success = [[dict valueForKey:API_KEY_SUCCESS] boolValue];
        ret.info = [dict valueForKey:API_KEY_INFO];
        ret.errors = [dict valueForKey:API_KEY_ERRORS];
        ret.data = [dict valueForKey:API_KEY_DATA];
    }
    
    return ret;
}

@end
