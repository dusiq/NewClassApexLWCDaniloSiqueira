import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import {fireEvent, registerListener} from 'c/pubsub';
import getAccounts from '@salesforce/apex/AccountControllerDesafio.getAccounts';

export default class AccountListItems extends LightningElement {

    //variaveis
    //@track accountId = null;
    @track filter = null;
    @track pageNumber = 1;
    @track accountsObj = [];

    //carrega as informações da propria página e armazena numa variável
    @wire(CurrentPageReference) pageRef;

    //toda vez que carregamos o componente ele executa automaticamente o que esta dentro deste metodo
    connectedCallback(){
        registerListener('filterChangeSearch',this.getFilter, this);
        this.getAccountsJS();
    }
    
    getFilter(filterParam){
        this.filter = filterParam;
        console.log('ENTROU NO GET FILTER ', this.filter);
        this.getAccountsJS();
    }
    
    //JS que busca o produto
    getAccountsJS(){
        getAccounts({filter : this.filter, pageNumber : this.pageNumber}).then( (response) => {            
            console.log('response getAccounts', response);
            this.accountsObj = response;          
        }).catch((error) => {
            console.log('ERRO AO BUSCAR CONTAS', error);
        });
    }

    //método do html, seleciona a conta
    handleAccountSelected(event){
        console.log('Capturou o evento do componente filho', event.detail);
        fireEvent(this.pageRef, 'selectedAccount', event.detail);
    }

    //método do html, paginação
    handlePreviousPage(){
        this.pageNumber = this.pageNumber -1;
        this.getProductsJS();
    }

    //método do html,paginação
    handleNextPage(){
        this.pageNumber = this.pageNumber +1;
        this.getProductsJS();
    }
}