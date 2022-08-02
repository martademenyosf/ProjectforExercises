import { createElement } from 'lwc';
import OsfWebToCase from 'c/osfWebToCase';
import getCustomFields from '@salesforce/apex/OSF_CaseController.getCustomFields';
import getCases from '@salesforce/apex/OSF_CaseController.getCases';

// Realistic data with a list of custom metadata 
const mockGetCustomFields = require('./data/getCustomFields.json');
const mockGetCases = require('./data/getCases.json');
/*
jest.mock(
    '@salesforce/apex/OSF_CaseController.getCustomFields
    ',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);
*/
// Mocking imperative Apex method call
jest.mock(
    '@salesforce/apex/OSF_CaseController.getCases',
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
// Mock getCustomFields Apex wire adapter
jest.mock(
    '@salesforce/apex/OSF_CaseController.getCustomFields',
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


describe('c-osf-web-to-case', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();        
    });

    // Helper function to wait until the microtask queue is empty.
    async function flushPromises() {
        return Promise.resolve();
    }    

    describe('getCustomFields @wire data', () => {
        it('renders seven records', () => {
            const element = createElement('c-osf-web-to-case', {
                is: OsfWebToCase
            });
            document.body.appendChild(element);
                
            // Emit data from @wire
            getCustomFields.emit(mockGetCustomFields);
            //getCustomFields.mockResolvedValue(mockGetCustomFields);
            
            return Promise.resolve().then(() => {
                // Select elements for validation
                const customFields = element.shadowRoot.querySelectorAll('lightning-input-field');
                expect(customFields.length).toBe(mockGetCustomFields.length + 1);
                //expect(customFieldElements[0].textContent).toBe(mockGetCustomFields[0].Value);
            });
        });
    });
    // Helper function to wait until the microtask queue is empty.
    async function flushPromises() {
        return Promise.resolve();
    }
    describe('getCases data', () => {

        it('passes the Owner Id to the Apex method correctly', async () => {
            const OWNER_ID = '0057R00000CQYqhQAH';
            const APEX_PARAMETERS = { ownerId: OWNER_ID };
    
            // Assign mock value for resolved Apex promise
            getCases.mockResolvedValue(mockGetCases);
    
            // Create initial element
            const element = createElement('c-osf-web-to-case', {
                is: OsfWebToCase
            });
            document.body.appendChild(element);
    
            // Select button for executing Apex call
            const buttonEl = element.shadowRoot.querySelector('lightning-button');
            buttonEl.click();
    
            // Wait for any asynchronous DOM updates
            await flushPromises();
    
            // Validate parameters of mocked Apex call
            expect(getCases.mock.calls[0][0]).toEqual(APEX_PARAMETERS);
        });
        it('renders 6 cases', async () => {
            // Assign mock value for resolved Apex promise
            getCases.mockResolvedValue(mockGetCases);
            //getCases.emit(mockGetCases);
     
            // Create initial element
            const element = createElement('c-osf-web-to-case', {
                is: OsfWebToCase
            });
            document.body.appendChild(element);

             // Select button for executing Apex call
             const buttonEl = element.shadowRoot.querySelector('lightning-button');
             buttonEl.click();  
            // Wait for any asynchronous DOM updates
            await flushPromises();
    
            // Select lightning-datatable 
            const tableEl = element.shadowRoot.querySelectorAll('lightning-datatable');
            expect(tableEl.length).toBe(mockGetCases.length);
            expect(tableEl.data[0].CaseNumber).toBe(mockGetCases[0].CaseNumber);                      
        });   
  
    });
});