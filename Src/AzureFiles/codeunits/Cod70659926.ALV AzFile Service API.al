codeunit 70659926 "ALV AzFile Service API"
{

    procedure FolderExist(folderName: Text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        request: HttpRequestMessage;
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
        result: Boolean;
        retValue: Text;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1?restype=directory', folderName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'HEAD';
        xmsversion := '2017-11-09';
        //contentType := 'text/plain; charset=utf-8';
        contentType := '';
        urlCanonicalPath := StrSubstNo('/%1/%2/%3', configuration.AzureBlobUsername, configuration.AzureWorkingPath, folderName);

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine);
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        request.SetRequestUri(azureApiEndpoint);
        request.GetHeaders(Headers);
        headers.Clear();
        headers.Add('Authorization', sharedKeyLite);
        headers.Add('x-ms-date', requestDateString);
        headers.Add('x-ms-version', xmsversion);
        request.Method := method;

        if client.Send(request, response) then begin
            if (response.IsSuccessStatusCode) then
                exit(true);
        end;
        exit(false);
    end;

    procedure FileExist(folderName: Text; fileName: Text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        request: HttpRequestMessage;
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
        result: Boolean;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'HEAD';
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

        request.SetRequestUri(azureApiEndpoint);
        request.GetHeaders(Headers);
        headers.Clear();
        headers.Add('Authorization', sharedKeyLite);
        headers.Add('x-ms-date', requestDateString);
        headers.Add('x-ms-version', xmsversion);
        request.Method := method;

        if client.Send(request, response) then begin
            if (response.IsSuccessStatusCode) then begin
                exit(true)
            end;
        end;
        exit(false)
    end;

    procedure List(folderName: Text; var directoryList: List of [Text]): Boolean
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
        retValue: Text;
        lXmlDocument: XmlDocument;
        lFileNameXmlNode: XmlNode;
        lXmlNode: XMLNode;
        lXmlNodeList: XMLNodeList;
        result: Boolean;
        fileName: Text;
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
            result := response.Content().ReadAs(retValue);
            if (result = true) then begin
                XmlDocument.ReadFrom(retValue, lXmlDocument);
                if lXmlDocument.SelectNodes('//File', lXmlNodeList) then begin
                    foreach lFileNameXmlNode in lXmlNodeList do begin
                        if lFileNameXmlNode.SelectSingleNode('Name', lXmlNode) then begin
                            fileName := lXmlNode.AsXmlElement.InnerText;
                            directoryList.Add(fileName);
                        end;
                    end;
                end;
            end;
            exit(result);
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

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Get(azureApiEndpoint, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure GetFileInfo(folderName: Text; fileName: Text; var output: DateTime): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        request: HttpRequestMessage;
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
        fileDateHeader: Array[10] of Text;
        LastModified: DateTime;
        result: Boolean;
        dateConverter: Codeunit "Type Helper";
        returnVar: Variant;
        dateFormat: Text;
        cultureName: Text;
        dateBuffer: Text;
    begin
        if not configuration.FindFirst() then exit(false);

        //File service REST API: https://docs.microsoft.com/it-it/rest/api/storageservices/file-service-rest-api
        urlFolderPart := StrSubstNo('%1/%2', folderName, fileName);
        azureApiEndpoint := StrSubstNo('%1/%2', configuration.AzureBlobUri, urlFolderPart);

        requestDateString := GetUTCDate(CurrentDateTime());
        method := 'HEAD';
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

        request.SetRequestUri(azureApiEndpoint);
        request.GetHeaders(Headers);
        headers.Clear();
        headers.Add('Authorization', sharedKeyLite);
        headers.Add('x-ms-date', requestDateString);
        headers.Add('x-ms-version', xmsversion);
        request.Method := method;

        if client.Send(request, response) then begin
            if (response.IsSuccessStatusCode) then begin

                response.Content().GetHeaders(headers);
                if (headers.Contains('Last-Modified')) then begin
                    headers.GetValues('Last-Modified', fileDateHeader);
                    dateBuffer := fileDateHeader[1];
                    if (StrLen(dateBuffer) = 29) then begin
                        //[1]:'Mon, 18 May 2020 10:25:32 GMT'
                        //dateBuffer := COPYSTR(dateBuffer, 6, 20);
                        dateFormat := 'ddd, dd MMM yyyy HH:mm:ss GMT';
                        cultureName := '';
                        returnVar := CREATEDATETIME(TODAY, TIME);
                        result := dateConverter.Evaluate(returnVar, dateBuffer, dateFormat, cultureName);
                        if (result = true) then begin
                            output := returnVar;
                            exit(true);
                        end;
                    end;
                end;

            end;
            exit(false)
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
    var
        memoryStream: Codeunit "MemoryStream Wrapper";
        contentLength: Integer;
        stream: InStream;
    begin
        // Load the memory stream and get the size
        memoryStream.Create(0);
        memoryStream.ReadFrom(inStream);
        contentLength := memoryStream.Length();
        memoryStream.SetPosition(0);
        memoryStream.GetInStream(stream);

        PutFileInit(folderName, fileName, contentLength, output);
        PutFileRange(folderName, fileName, stream, contentLength, output);
    end;

    procedure PutFileInit(folderName: Text; fileName: Text; contentLength: Integer; var output: Text): Boolean
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


        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-content-length:%7%6x-ms-date:%3%6x-ms-type:file%6x-ms-version:%4%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine, Format(contentLength));
        sharedKeyLite := EncryptionManagement.GenerateBase64KeyedHashAsBase64String(canonicalizedStringToBuild, configuration.AzureBlobToken, 2);
        sharedKeyLite := StrSubstNo('SharedKeyLite %1:%2', configuration.AzureBlobUsername, sharedKeyLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', sharedKeyLite);
        client.DefaultRequestHeaders().Add('x-ms-content-length', Format(contentLength));
        client.DefaultRequestHeaders().Add('x-ms-date', requestDateString);
        client.DefaultRequestHeaders().Add('x-ms-type', 'file');
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Put(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure PutFileRange(folderName: Text; fileName: Text; stream: InStream; contentLength: Integer; var output: Text): Boolean
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
        xmsrange: Text;
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
        xmsrange := StrSubstNo('bytes=0-%1', Format(contentLength - 1));

        // REST API Shared Key https://docs.microsoft.com/en-us/azure/storage/common/storage-rest-api-auth
        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStringToBuild := StrSubstNo('%1%6%6%2%6%6x-ms-content-length:%7%6x-ms-date:%3%6x-ms-range:%8%6x-ms-type:file%6x-ms-version:%4%6x-ms-write:update%6%5', method, contentType, requestDateString, xmsversion, urlCanonicalPath, newLine, Format(contentLength), xmsrange);
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
        headers.Add('x-ms-content-length', Format(contentLength));
        headers.Add('x-ms-date', requestDateString);
        headers.Add('x-ms-range', xmsrange);
        headers.Add('x-ms-type', 'file');
        headers.Add('x-ms-version', xmsversion);
        headers.Add('x-ms-write', 'update');
        headers.Add('Content-Length', Format(contentLength));

        if client.Put(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(output))
        end;
    end;

    procedure GetUTCDate(currentDateTime: DateTime): Text
    var
        requestDateString: Text;
    begin
        //UTC: sample Mon, 18 May 2020 08:53:13 GMT
        requestDateString := Format(currentDateTime, 0, '<Weekday Text,3>, <Day> <Month Text,3> <Year4> <Hours24,2>:<Minutes,2>:<Seconds,2> GMT');
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