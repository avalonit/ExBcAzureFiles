/*codeunit 70659925 "ALV AzAzure File Service API"
{


    procedure Download(containerName: Text; blobName: Text; var stream: InStream): Boolean
    var
        blobStorageAccount: Record "ALV AzConnector Configuration";
        client: HttpClient;
        response: HttpResponseMessage;
    begin
        if not blobStorageAccount.FindFirst() then exit(false);
        //GET https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        StrSubstNo('%1/%2/%3?%4', blobStorageAccount.AzureUri, containerName, blobName, blobStorageAccount.AzureToken
        if not client.Get(), response) then exit(false);
        exit(response.Content().ReadAs(stream))
    end;

    procedure Upload(containerName: Text; blobName: Text; var stream: InStream): Boolean
    var
        blobStorageAccount: Record "ALV AzConnector Configuration";
        memoryStream: Codeunit "MemoryStream Wrapper";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headers: HttpHeaders;
        len: Integer;
    begin
        if not blobStorageAccount.FindFirst() then exit;
        client.SetBaseAddress(blobStorageAccount.AzureUri);

        // Load the memory stream and get the size
        memoryStream.Create(0);
        memoryStream.ReadFrom(stream);
        len := memoryStream.Length();
        memoryStream.SetPosition(0);
        memoryStream.GetInStream(stream);

        // Write the Stream into HTTP Content and change the needed Header Information 
        content.WriteFrom(stream);
        content.GetHeaders(headers);
        headers.Remove('Content-Type');
        headers.Add('Content-Type', 'application/octet-stream');
        headers.Add('Content-Length', StrSubstNo('%1', len));
        headers.Add('x-ms-blob-type', 'BlockBlob');

        //PUT https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        exit(client.Post()(StrSubstNo('%1/%2/%3?%4', blobStorageAccount.AzureUri, containerName, blobName, blobStorageAccount.AzureToken), content, response));
    end;

}*/

