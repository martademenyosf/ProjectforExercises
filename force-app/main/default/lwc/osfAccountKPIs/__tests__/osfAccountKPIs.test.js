import { createElement } from 'lwc';
import OsfAccountKPIs from 'c/osfAccountKPIs';

import getOrdersAmountCurrentYear from '@salesforce/apex/OSF_AccountController.getOrdersAmountCurrentYear';
import getOrdersAmountCurrentYearMinus5 from '@salesforce/apex/OSF_AccountController.getOrdersAmountCurrentYearMinus5';
import getAccountKPIs from '@salesforce/apex/OSF_AccountController.getAccountKPIs';

const mockGetOrdersAmountCurrentYear = require('./data/getOrdersAmountCurrentYear.json');

// Mocking imperative Apex method call
/*
jest.mock(
    '@salesforce/apex/OSF_AccountController.getOrdersAmountCurrentYear',
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);
*/
describe('c-osf-account-kp-is', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
            // Prevent data saved on mocks from leaking between tests
            jest.clearAllMocks();              
        }
    });
    
    // Helper function to wait until the microtask queue is empty. This is needed for promise
    // timing.
    async function flushPromises() {
        return Promise.resolve();
    }    

    describe('OrdersAmounts @wire data', () => {
        it('wire ordersAmountCurrentYear data', () => {
            const element = createElement('c-osf-account-kp-is', {
                is: OsfAccountKPIs
            });
            document.body.appendChild(element);
                
            // Emit data from @wire
            getOrdersAmountCurrentYear.emit(mockGetOrdersAmountCurrentYear);
            //getOrdersAmountCurrentYear.mockResolvedValue(mockGetOrdersAmountCurrentYear);
            
            return Promise.resolve().then(() => {
                // Select elements for validation
                const ordersAmountCurrentYear = element.shadowRoot.querySelectorAll('lightning-formatted-number');
                expect(ordersAmountCurrentYear[0].value).toBe(mockGetOrdersAmountCurrentYear.ordersAmountValue);
            });
        });
    });
});