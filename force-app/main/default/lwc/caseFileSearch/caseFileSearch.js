import { LightningElement, track, api } from 'lwc';
import searchFiles from '@salesforce/apex/CaseFileSearchController.searchFiles';

export default class CaseFileSearch extends LightningElement {
    @api recordId;
    @track searchTerm = '';
    @track searchResults = [];
    columns = [
        { label: 'Title', fieldName: 'Title' },
        {
            label: 'View',
            type: 'button',
            typeAttributes: {
                label: 'View File',
                name: 'view_file',
                variant: 'brand'
            }
        },
        {
            label: 'Download',
            type: 'button',
            typeAttributes: {
                label: 'Download',
                name: 'download_file',
                variant: 'neutral'
            }
        }
    ];

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
    }

    handleSearch() {
        searchFiles({ caseId: this.recordId, searchTerm: this.searchTerm })
            .then(result => {
                this.searchResults = result;
                console.log('Search Results:', result);
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        const fileExtension = row.FileExtension.toLowerCase();
        let url = '';

        if (actionName === 'view_file') {
            console.log('View File:', row);
            url = `/lightning/r/ContentDocument/${row.ContentDocumentId}/view`;
            console.log('View URL:', url);
            window.open(url, '_blank');
        } else if (actionName === 'download_file') {
            console.log('Download File:', row);
            url = `/sfc/servlet.shepherd/version/download/${row.LatestPublishedVersionId}`;
            console.log('Download URL:', url);
            window.open(url, '_blank');
        }
    }
}
