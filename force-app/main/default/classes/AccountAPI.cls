//DESAFIO - Criar uma API que consulta as contas, onde eu posso pesquisar uma conta pelo nome
//DESAFIO - Na mesma classe de API criar um post que receba os dados básicos e inclua a conta, podendo retornar apenas com um OK no JSON
//**Post recebe um wrapper com os campos em portugues */

@RestResource(urlMapping = '/AulaDeApex/Accounts/*')

global with sharing class AccountAPI {
    
    @HttpGet
    global static void getAccount(){
        RestResponse resultRest = RestContext.response;
        String asParamStr = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
        String nome = String.IsNotBlank(asParamStr) ? RestContext.request.params.get('nome') : '';
        List<Account> accountList = new List<Account>();
        if(String.IsNotBlank(nome)){
            accountList = [SELECT Id, Name FROM Account WHERE Name = :nome];
        }else{
            accountList = [SELECT Id, Name FROM Account];
        }
        resultRest.responseBody = Blob.valueOf(JSON.serializePretty(accountList));
        resultRest.StatusCode = 200;
    }

    @HttpPost
    global static void insertUpdateAccounts(List<AccountApiWrapper> accountList){

        List<Account> accountsInsertList = new List<Account>();

        for(AccountApiWrapper cTemp : accountList){
            Account accountObj = new Account();
            if(String.IsNotBlank(cTemp.id_account)){
                accountObj = new Account(
                    Name = cTemp.nome
                    ,Phone = cTemp.telefone
                    ,Email__c  = cTemp.email
                    ,Id  = cTemp.id_account);
            }else{
                accountObj = new Account(
                    Name = cTemp.nome
                    ,Phone = cTemp.telefone
                    ,Email__c  = cTemp.email);
            }

            accountsInsertList.add(accountObj);
        }

        RestResponse resultRest = RestContext.response;
        List<String> idsAccountsList = new List<String>();

        if(accountsInsertList.size() > 0){
            Database.UpsertResult[] results = Database.upsert(accountsInsertList);
            for(Integer index = 0; index < results.size(); index++){
                if(results[index].isSuccess()){
                    Id idDFor = results[index].Id;
                    idsAccountsList.add(idDFor);
                }else{
                    idsAccountsList.add('Erro');
                }
            }    
            resultRest.responseBody = Blob.valueOf(JSON.serializePretty(idsAccountsList));
            resultRest.StatusCode = 200;                
        }
    }
}
