import { LightningElement, api, track } from 'lwc';

export default class AccountListItemsCard extends LightningElement {
    @track _account;
    @api
    get account(){
        return this._account;
    }
    set account(value){

        let image = value.PhotoUrl ? value.PhotoUrl : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png';
        console.log('value', value);
        this._account = {id : value.Id, nome : value.Name, imagem : image};

    }

    handleAccountSelected(){
        const accountSelected = new CustomEvent("selected", {
            detail: JSON.stringify(this._account),
        });
        console.log('esta disparando o evento no componente filho');
        this.dispatchEvent(accountSelected);
    }

}