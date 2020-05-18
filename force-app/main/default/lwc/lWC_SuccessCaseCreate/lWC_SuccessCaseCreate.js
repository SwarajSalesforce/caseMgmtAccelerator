import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class LWC_SuccessCaseCreate extends NavigationMixin(LightningElement) {

    navigateHomePage(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'home'
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }

}