public with sharing class AccountControllerDesafio {    

    @AuraEnabled(cacheable=true)
    public static PageResultWrapper getAccounts(String filter, Integer pageNumber){

        Integer pageSize = 9;
        String whereClausule = '';
        Integer offSet = (pageNumber-1)*pageSize;
        
        if(String.IsNotBlank(filter)){
            whereClausule += ' WHERE Name LIKE \'%'+filter+'%\'';
        }
    
        PageResultWrapper result = new PageResultWrapper();
        result.tamanhoDaPagina = pageSize;
        result.totalItems = Database.countQuery('SELECT count() FROM Account '+whereClausule);
        result.allDatas = Database.query('SELECT Id, Name, PhotoUrl FROM Account '+whereClausule+' LIMIT :pageSize OFFSET :offset ');

        return result;
    }
    

}
