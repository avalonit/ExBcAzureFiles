codeunit 70659928 "ALV Zip Helper"
{

    trigger OnRun()
    begin
    end;

    var
        ZipHelper: Codeunit "Data Compression";
        AzFileHelper: Codeunit "ALV AzFile Service API";

    [Scope('Cloud')]
    procedure PackageZip(OutputPathName: Text; FolderToZip: Text)
    var
        directoryList: List of [Text];
        fileName: Text;
        downloadStream: InStream;
        zipOutStream: OutStream;
        zipInStream: InStream;
        result: Boolean;
        outputText: Text;
        FileMgt: Codeunit "File Management";
        zipFileName: Text;
        zipFolder: Text;
        blobStorage: Codeunit "Temp Blob";
    begin
        zipFileName := FileMgt.GetFileName(OutputPathName);
        zipFolder := FileMgt.GetDirectoryName(OutputPathName);
        zipFolder := zipFolder.Replace('\', '/');

        if (zipFolder.StartsWith('/')) then
            zipFolder := zipFolder.Substring(2);

        AzFileHelper.List(FolderToZip, directoryList);

        if (directoryList.Count > 0) then begin
            ZipHelper.CreateZipArchive();
            foreach fileName in directoryList do begin
                result := AzFileHelper.Download(FolderToZip, fileName, downloadStream);
                if (result) then begin
                    ZipHelper.AddEntry(downloadStream, fileName);
                end;
            end;

            blobStorage.CreateOutStream(zipOutStream);
            ZipHelper.SaveZipArchive(zipOutStream);
            ZipHelper.CloseZipArchive();
            blobStorage.CreateInStream(zipInStream);

            AzFileHelper.Upload(zipFolder, zipFileName, zipInStream, outputText);
        end;
    end;

    [Scope('Cloud')]
    procedure PackageUnzip(ArchiveFileNameIn: Text; OutFolder: Text)
    var
        directoryList: List of [Text];
        FileMgt: Codeunit "File Management";
        fileName: Text;
        zipFileName: Text;
        zipFolder: Text;
        downloadStream: InStream;
        result: Boolean;
        zipOutStream: OutStream;
        zipInStream: InStream;
        entryLength: Integer;
        outputText: Text;
        blobStorage: Codeunit "Temp Blob";
    begin
        zipFileName := FileMgt.GetFileName(ArchiveFileNameIn);
        zipFolder := FileMgt.GetDirectoryName(ArchiveFileNameIn);
        zipFolder := zipFolder.Replace('\', '/');

        if (zipFolder.StartsWith('/')) then
            zipFolder := zipFolder.Substring(2);

        OutFolder := OutFolder.Replace('\', '/');
        if (OutFolder.StartsWith('/')) then
            OutFolder := OutFolder.Substring(2);

        result := AzFileHelper.Download(zipFolder, zipFileName, downloadStream);

        ZipHelper.OpenZipArchive(downloadStream, false);
        ZipHelper.GetEntryList(directoryList);

        if (directoryList.Count > 0) then begin
            foreach fileName in directoryList do begin
                blobStorage.CreateOutStream(zipOutStream);
                ZipHelper.ExtractEntry(fileName, zipOutStream, entryLength);
                blobStorage.CreateInStream(zipInStream);
                result := AzFileHelper.Upload(OutFolder, fileName, zipInStream, outputText);
            end;

        end;
        ZipHelper.CloseZipArchive();
        //ZipHelper.ExtractZipFile(ArchiveFileNameIn, OutFolder);
    end;
}

