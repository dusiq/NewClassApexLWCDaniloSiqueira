@isTest
public class AccountTriggerTest {
    
    //Teste 1 - criar uma conta com tarefas
    @isTest
    static void AccountTriggerTest() {

        Account accountObj = new Account();
        accountObj.Name = 'Teste 1';
        accountObj.OwnerShip = 'Private';
        accountObj.Phone = '5555555';

        insert accountObj;

        List<Task> taskList = new List<Task>([SELECT Id FROM Task WHERE WhatId = :accountObj.Id AND Subject = 'Verificar dados das contas']);

        System.AssertEquals(taskList.size(),1);
    }

    //Teste 2 - criar uma conta sem tarefas
    @isTest
    static void contaSemTarefas() {

        Account accountObj = new Account();
        accountObj.Name = 'Teste 1';
        accountObj.OwnerShip = '';
        accountObj.Phone = '5555555';

        insert accountObj;

        List<Task> taskList = new List<Task>([SELECT Id FROM Task WHERE WhatId = :accountObj.Id AND Subject = 'Verificar dados das contas']);

        System.AssertEquals(taskList.size(),0);
    }

    //Teste 3 - massa de dados grande
    @isTest
    static void contaMassaDados() {

        List<Account> accountList = new List<Account>();
        Integer qtdContas = 151;
        for(Integer i = 1; i <= qtdContas; i++){
            Account accObj = new Account();
            accObj.Name = 'Conta '+i;
            accObj.OwnerShip = 'Private';
            accObj.Phone = '555456';
            accountList.add(accObj);
        }

        insert accountList;

        List<Task> tasksList = new List<Task>([SELECT Id FROM Task WHERE WhatId IN :accountList AND Subject = 'Verificar dados das contas']);

        System.AssertEquals(tasksList.size(),100);
    }
}
