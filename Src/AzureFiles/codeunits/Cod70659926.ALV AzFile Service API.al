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
        newLine: Text;
        charCr: Char;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1?restype=directory&comp=list', folderName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'GET';
        xmsversion := GetXmsVersion();
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3?comp=list', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine);
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


    procedure Download(folderName: Text; fileName: Text; var output: Text): Boolean
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
        newLine: Text;
        charCr: Char;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'GET';
        xmsversion := '2017-11-09';
        //contentType := 'text/plain; charset=utf-8';
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3/%4', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName, fileName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        Message(canonicalizedStringToBuild);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Get(azureApiEndpoint, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure Download(folderName: Text; fileName: Text; var output: InStream): Boolean
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
        newLine: Text;
        charCr: Char;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'GET';
        xmsversion := GetXmsVersion();
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3/%4', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName, fileName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Get(azureApiEndpoint, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure Delete(folderName: Text; fileName: Text; var output: Text): Boolean
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
        newLine: Text;
        charCr: Char;
    begin
        if not configuration.FindFirst() then exit(false);

        //Delete https://docs.microsoft.com/it-it/rest/api/storageservices/delete-file2
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'DELETE';
        xmsversion := GetXmsVersion();
        //contentType := 'text/plain; charset=utf-8';
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3/%4', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName, fileName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Delete(azureApiEndpoint, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure Upload(folderName: Text; fileName: Text; inStream: InStream; var output: Text): Boolean
    begin
        PutFileInit(folderName, fileName, inStream, output);
        PutFileRange(folderName, fileName, inStream, output);
    end;

    procedure PutFileInit(folderName: Text; fileName: Text; stream: InStream; var output: Text): Boolean
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
        newLine: Text;
        charCr: Char;
        contentLength: Text;
        memoryStream: Codeunit "MemoryStream Wrapper";
    begin
        if not configuration.FindFirst() then exit(false);

        //Create (Init file) https://docs.microsoft.com/en-us/rest/api/storageservices/create-file
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'PUT';
        xmsversion := '2017-11-09';
        contentType := 'text/plain; charset=utf-8';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3/%4', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName, fileName);

        // Load the memory stream and get the size
        memoryStream.Create(0);
        memoryStream.ReadFrom(stream);
        contentLength := Format(memoryStream.Length());

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-content-length:%7%6x-ms-date:%3%6x-ms-type:file%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine, contentLength);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-content-length', contentLength);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-type', 'file');
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Put(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure PutFileRange(folderName: Text; fileName: Text; stream: InStream; var output: Text): Boolean
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
        newLine: Text;
        charCr: Char;
        contentLength: Text;
        xmsrange: Text;
        memoryStream: Codeunit "MemoryStream Wrapper";
    begin
        if not configuration.FindFirst() then exit(false);

        //Create Range https://docs.microsoft.com/en-us/rest/api/storageservices/put-range
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2?comp=range', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'PUT';
        xmsversion := GetXmsVersion();
        contentType := 'text/plain; charset=utf-8';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3/%4?comp=range', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName, fileName);

        // Load the memory stream and get the size
        memoryStream.Create(0);
        memoryStream.ReadFrom(stream);
        contentLength := Format(memoryStream.Length());
        xmsrange := StrSubstNo('bytes=0-%1', Format(memoryStream.Length() - 1));
        memoryStream.SetPosition(0);
        memoryStream.GetInStream(stream);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-content-length:%7%6x-ms-date:%3%6x-ms-range:%8%6x-ms-type:file%6x-ms-version:%4%6x-ms-write:update%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine, contentLength, xmsrange);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        /*
        client.DefaultRequestHeaders().Add('x-ms-content-length', contentLength);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-range', 'bytes=0-554');
        client.DefaultRequestHeaders().Add('x-ms-type', 'file');
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);
        client.DefaultRequestHeaders().Add('x-ms-write', 'update');
        */

        content.WriteFrom(stream);
        Content.GetHeaders(Headers);
        headers.Remove('Content-Length');
        headers.Add('x-ms-content-length', contentLength);
        headers.Add('x-ms-date', requestDateString);
        headers.Add('x-ms-range', xmsrange);
        headers.Add('x-ms-type', 'file');
        headers.Add('x-ms-version', xmsversion);
        headers.Add('x-ms-write', 'update');
        headers.Add('Content-Length', contentLength);

        if client.Put(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure GetUTCDate(currentDateTime: DateTime): Text
    var
        requestDateString: Text;
    begin
        //UTC: sample Mon, 18 May 2020 08:53:13 GMT
        requestDateString := Format(currentDateTime, 0, '<Weekday Text,3>, <Day> <Month Text> <Year4> <Hours24,2>:<Minutes,2>:<Seconds,2> GMT');
        exit(requestDateString);
    end;

    procedure GetXmsVersion(): Text
    var
        xmsVersion: Text;
    begin
        xmsVersion := '2017-11-09';
        exit(xmsVersion);
    end;
}