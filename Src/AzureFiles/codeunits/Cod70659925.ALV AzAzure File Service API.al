codeunit 70659925 "ALV AzAzure File Service API"
{
    procedure Download(containerName: Text; fileName: Text; var stream: InStream): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        azureApiEndpoint: Text;
        azureFileName: Text;
        azureBlob: record TempBlob temporary;
    begin
        //https://github.com/microsoft/AL/issues/1201
        if not configuration.FindFirst() then exit(false);
        azureFileName := StrSubstNo('%1/%2', containerName, fileName);
        azureApiEndpoint := StrSubstNo('%1/AzureFileDownload?code=%2&fileName=%3', configuration.AzureFunctionUri, configuration.AzureFunctionKey, azureFileName);
        //headers.Clear();
        //headers.Add('fileName', azureFileName);
        //content.GetHeaders(headers);

        azureBlob.Init;
        azureBlob.Blob.CreateInStream(Stream);

        if client.Post(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(stream))
        end;
    end;

    procedure Download(containerName: Text; fileName: Text; var text: text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        content: HttpContent;
        azureApiEndpoint: Text;
        azureFileName: Text;
    begin
        //https://github.com/microsoft/AL/issues/1201
        if not configuration.FindFirst() then exit(false);
        azureFileName := StrSubstNo('%1/%2', containerName, fileName);
        azureApiEndpoint := StrSubstNo('%1/AzureFileDownload?code=%2&fileName=%3', configuration.AzureFunctionUri, configuration.AzureFunctionKey, azureFileName);

        //headers.Clear();
        //headers.Add('fileName', azureFileName);
        //content.GetHeaders(headers);

        if client.Post(azureApiEndpoint, content, response) then begin
            exit(response.Content().ReadAs(text))
        end;
    end;

    procedure Upload(containerName: Text; fileName: Text; var stream: InStream): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        memoryStream: Codeunit "MemoryStream Wrapper";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headers: HttpHeaders;
        len: Integer;
        azureApiEndpoint: Text;
        azureFileName: Text;
    begin
        if not configuration.FindFirst() then exit;

        azureFileName := StrSubstNo('%1/%2', containerName, fileName);
        azureApiEndpoint := StrSubstNo('%1/AzureFileUpload?code=%2&fileName=%3', configuration.AzureFunctionUri, configuration.AzureFunctionKey, azureFileName);

        // Load the memory stream and get the size
        memoryStream.Create(0);
        memoryStream.ReadFrom(stream);
        len := memoryStream.Length();
        memoryStream.SetPosition(0);
        memoryStream.GetInStream(stream);

        // Write the Stream into HTTP Content and change the needed Header Information 
        content.WriteFrom(stream);
        //headers.Clear();
        //headers.Add('fileName', azureFileName);
        //content.GetHeaders(headers);

        exit(client.Post(azureApiEndpoint, content, response));
    end;

    procedure Upload(containerName: Text; fileName: Text; var text: Text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        memoryStream: Codeunit "MemoryStream Wrapper";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headers: HttpHeaders;
        len: Integer;
        azureApiEndpoint: Text;
        azureFileName: Text;
    begin
        if not configuration.FindFirst() then exit;

        azureFileName := StrSubstNo('%1/%2', containerName, fileName);
        azureApiEndpoint := StrSubstNo('%1/AzureFileUpload?code=%2&fileName=%3', configuration.AzureFunctionUri, configuration.AzureFunctionKey, azureFileName);

        // Load the text
        content.WriteFrom(text);

        // Write the Stream into HTTP Content and change the needed Header Information 
        //headers.Clear();
        //content.GetHeaders(headers);
        //headers.Add('fileName', azureFileName);

        exit(client.Post(azureApiEndpoint, content, response));
    end;

}