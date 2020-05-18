codeunit 70659926 "ALV AzFile Service API"
{
    procedure List(folderName: Text; var directoryList: text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        azureApiEndpoint: Text;
        urlFolderPart: Text;
        requestDateString: Text;
        sharedKeyLite: Text;
        canonicalizedStringToBuild: Text;
        method: Text;
        xmsversion: Text;
        urlCanonicalPath: Text;
        contentType: Text;
        EncryptionManagement: codeunit "Cryptography Management";
        lineLine: Text;
        charCr: Char;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1?restype=directory&comp=list', folderName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        //UTC: sample Mon, 18 May 2020 08:53:13 GMT
        requestDateString := Format(CurrentDateTime(), 0, '<Weekday Text,3>, <Day> <Month Text> <Year4> <Hours24>:<Minutes>:<Seconds> GMT');
        method := 'GET';
        xmsversion := '2017-11-09';
        //contentType := 'text/plain; charset=utf-8';
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3?comp=list', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        lineLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%7%2%8%9x-ms-date:%3%10x-ms-version:%4%10%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, lineLine, lineLine, lineLine, lineLine, lineLine, lineLine);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Get(azureApiEndpoint, response) then begin
            exit(response.Content().ReadAs(directoryList))
        end;
    end;


    procedure GetFile(folderName: Text; fileName: Text; var output: Text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        azureApiEndpoint: Text;
        urlFolderPart: Text;
        requestDateString: Text;
        sharedKeyLite: Text;
        canonicalizedStringToBuild: Text;
        method: Text;
        xmsversion: Text;
        urlCanonicalPath: Text;
        contentType: Text;
        EncryptionManagement: codeunit "Cryptography Management";
        lineLine: Text;
        charCr: Char;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        //UTC: sample Mon, 18 May 2020 08:53:13 GMT
        requestDateString := Format(CurrentDateTime(), 0, '<Weekday Text,3>, <Day> <Month Text> <Year4> <Hours24>:<Minutes>:<Seconds> GMT');
        method := 'GET';
        xmsversion := '2017-11-09';
        //contentType := 'text/plain; charset=utf-8';
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3?comp=list', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        lineLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%7%2%8%9x-ms-date:%3%10x-ms-version:%4%10%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, lineLine, lineLine, lineLine, lineLine, lineLine, lineLine);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Put(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;
}