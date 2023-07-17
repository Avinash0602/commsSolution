global with sharing class newConnect_ResumeOpportunityController implements vlocity_cmt.VlocityOpenInterface {
    
    global newConnect_ResumeOpportunityController () {
    }
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
    Boolean result = false;
       try{
            System.debug('In newConnect_ResumeOpportunityController :invokeMethod()');
            if(methodName.equalsIgnoreCase('fetchOpportunities')){
                result = fetchOpportunities(inputMap,outMap,options);
                
            }
         
       }catch(Exception e){
            System.debug('newConnect_ResumeOpportunityController :invokeMethod -> exception: '+e);
            System.debug('Line: ' + e.getLineNumber());
            result = false;
        }
        return result;
    }   

    public static boolean fetchOpportunities(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try{
            Id userId = UserInfo.getUserId();
            Integer pageSize;
            Integer offset;
            try {
                pageSize = (Integer) options.get('pageSize');
                offset = (Integer) options.get('offset'); 
            } catch (Exception e) {
                System.debug('PageSize/Offset not set using defaults');
            }
            if( pageSize == null ||  offset == null ){
                pageSize = 200;
                offset = 0;
            }
            //String userCountry = (String)[Select Business_Unit__c from User where Id = :userId LIMIT 1].Business_Unit__c;
            List<Opportunity> oppList = (List<Opportunity>) [select id,name,lastmodifiedDate,StageName from opportunity where ownerId = :userId and StageName ='Prospecting' and Type='New Business' and accountId not IN (Select accountId from Order where Account.OwnerId = :userId ) WITH SECURITY_ENFORCED order by createdDate desc LIMIT :pageSize OFFSET :offset ];
            System.debug('newConnect_ResumeOpportunityController :fetchOpportunitiesTest() -> Opporunities'+oppList);
            List<Map<String,Object>> opportunityList = new List<Map<String,Object>>();
            for(opportunity opp : oppList){
                    opportunityList.add(new Map<String,Object> {
                                                            'Id' => opp.Id,
                                                            'Name' => opp.Name,
                                                            'StageName' => opp.StageName,
                                                            'LastModifiedDate' => opp.LastModifiedDate
                                                        }
                                );
                }   
            
            outMap.put('Opportunities',opportunityList);
            return true;
        }catch (Exception e){
            System.debug('newConnect_ResumeOpportunityController :fetchOpportunities -> exception: '+e);
            System.debug('Line: ' + e.getLineNumber());
            return false;
        }
    }   
    
}