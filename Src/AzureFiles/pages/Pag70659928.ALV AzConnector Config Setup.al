page 70659928 "ALV AzConnector Config Setup"
{
    Caption = 'ALV AzConnector Config Setup';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALV AzConnector Configuration";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("AzureNo"; "AzureNo")
                {
                    ApplicationArea = All;
                    Caption = 'No';
                }

                field("AzureCode"; "AzureCode")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field("AzureBlobUri"; "AzureBlobUri")
                {
                    ApplicationArea = All;
                    Caption = 'Blob Uri';
                }

                field("AzureBlobToken"; "AzureBlobToken")
                {
                    ApplicationArea = All;
                    Caption = 'Blob Token';
                }
                field("AzureBlobUsername"; "AzureBlobUsername")
                {
                    ApplicationArea = All;
                    Caption = 'Blob Username';
                }
                field("AzureBlobPassword"; "AzureBlobPassword")
                {
                    ApplicationArea = All;
                    Caption = 'Blob Password';
                }

                field("AzureFunctionUri"; "AzureFunctionUri")
                {
                    ApplicationArea = All;
                    Caption = 'Azure Function URL';
                }
                field("AzureFunctionKey"; "AzureFunctionKey")
                {
                    ApplicationArea = All;
                    Caption = 'Azure Function Key';
                }


                field("AzureWorkingPath"; AzureWorkingPath)
                {
                    ApplicationArea = All;
                    Caption = 'Working Path';
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("TestBinDownload")
            {
                Caption = 'Binary Download';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzAzure File Service API";
                    stream: InStream;
                begin
                    fileService.Download('foo', 'jeager3.jpg', stream);
                end;
            }

            action("TestBinaryUpload")
            {
                Caption = 'Binary Upload';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzAzure File Service API";
                    stream: InStream;
                    downloadResult: Boolean;
                    uploadResult: Boolean;
                begin
                    //https://github.com/microsoft/AL/issues/1201
                    uploadResult := false;
                    downloadResult := fileService.Download('foo', 'jeager3.jpg', stream);
                    if (downloadResult = true) then
                        uploadResult := fileService.Upload('foo', 'jeager10.jpg', stream);

                    if (uploadResult = false) then
                        Message('Error');

                end;
            }

            action("TestTxtDownload")
            {
                Caption = 'Txt Download';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzAzure File Service API";
                    returnText: text;
                    downloadResult: Boolean;
                begin
                    downloadResult := fileService.Download('foo', 'sample1.txt', returnText);
                    if (downloadResult = false) then
                        Message('Error');
                end;
            }

            action("TestTxtUpload")
            {
                Caption = 'Txt Upload';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzAzure File Service API";
                    returnText: Text;
                    uploadResult: Boolean;
                begin
                    //https://github.com/microsoft/AL/issues/1201
                    returnText := 'FOO';
                    uploadResult := fileService.Upload('foo', 'sample3.txt', returnText);

                    if (uploadResult = false) then
                        Message('Error');

                end;
            }

            action("AzureFolderExist")
            {
                Caption = 'AzureFolderExist';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzFile Service API";
                    opResult: Boolean;
                begin
                    opResult := fileService.FolderExist('foo');

                    if (opResult = false) then begin
                        Message('Folder foo does not exist');
                    end
                    else begin
                        Message('Folder foo exists')
                    end;

                    opResult := fileService.FolderExist('nofoo');

                    if (opResult = false) then begin
                        Message('Folder nofoo does not exist');
                    end
                    else begin
                        Message('Folder nofoo exists')
                    end;

                    opResult := fileService.FileExist('foo', 'sample3.txt');

                    if (opResult = false) then begin
                        Message('File sample3.txt does not exist');
                    end
                    else begin
                        Message('File sample3.txt exists')
                    end;

                    opResult := fileService.FileExist('foo', 'filedontexist.txt');

                    if (opResult = false) then begin
                        Message('File filedontexist.txt does not exist');
                    end
                    else begin
                        Message('File filedontexist.txt exists')
                    end;

                end;
            }
            action("AzureFileGetList")
            {
                Caption = 'AzureFileList';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzFile Service API";
                    returnList: List of [Text];
                    opResult: Boolean;
                begin
                    opResult := fileService.List('foo', returnList);

                    if (opResult = false) then begin
                        Message('Error');
                    end
                    else begin
                        Message(FORMAT(returnList.Count()));
                    end;

                end;
            }

            action("AzureFileGetInfo")
            {
                Caption = 'AzureFileGetInfo';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzFile Service API";
                    returnText: Variant;
                    opResult: Boolean;
                begin
                    opResult := fileService.GetFileInfo('foo', 'sample3.txt', returnText);

                    if (opResult = false) then begin
                        Message('Error');
                    end
                    else begin
                        Message(FORMAT(returnText));
                    end;

                end;
            }


            action("AzureFileGetFile")
            {
                Caption = 'AzureFileGetFile';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzFile Service API";
                    returnText: Text;
                    opResult1: Boolean;
                    opResult2: Boolean;
                    inStream: InStream;
                begin
                    opResult1 := fileService.Download('foo', 'sample2.txt', returnText);
                    opResult2 := fileService.Download('foo', 'dyn.jpg', inStream);

                    if (opResult1 = false) then begin
                        Message('Error');
                    end
                    else begin
                        Message(returnText);
                    end;

                    if (opResult2 = false) then
                        Message('Error');

                end;
            }

            action("AzureFilePutFile")
            {
                Caption = 'AzureFilePutAndDeleteFile';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    fileService: Codeunit "ALV AzFile Service API";
                    returnText: Text;
                    opResult: Boolean;
                    inStream: InStream;
                begin
                    opResult := fileService.Download('foo', 'dyn.jpg', inStream);

                    if (opResult = false) then begin
                        Message('Error');
                    end
                    else begin
                        opResult := fileService.Upload('foo', 'dyntry.jpg', inStream, returnText);
                        Message('PutFile ' + returnText);
                        opResult := fileService.Delete('foo', 'dyntry.jpg', returnText);
                        Message('DeleteFile ' + returnText);
                    end;


                end;
            }

            action("EncDecTest")
            {
                Caption = 'Enc/Dec Test';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    dotnetA: Codeunit "ALV DotNetActivity";
                    returnText1: Text;
                    returnText2: Text;
                    returnText3: Text;
                    textEnc: Text;
                    textDec: Text;

                begin
                    textEnc := 'VABoAGUAIABxAHUAaQBjAGsAIABiAHIAbwB3AG4AIABmAG8AeAAgAGoAdQBtAHAAZQBkACAAbwB2AGUAcgAgAHQAaABlACAAbABhAHoAeQAgAGQAbwBnAC4A';
                    textDec := 'The quick brown fox jumped over the lazy dog.';
                    returnText1 := dotnetA.EncodeB64(textDec);
                    returnText2 := dotnetA.DecodeB64(returnText1);

                    returnText3 := dotnetA.DecodeB64(textEnc);

                end;
            }

            action("XML2CSV")
            {
                Caption = 'XML2CSV';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendMail;
                ApplicationArea = All;

                trigger OnAction();
                var
                    dotnetA: Codeunit "ALV DotNetActivity";
                    returnText1: Text;
                    xmlFileName: Text;
                    xsdFileName: Text;
                    xslFileName: Text;
                    folderName: Text;

                begin
                    xmlFileName := 'tempXMLSingleIn.xsd';
                    xsdFileName := 'tempXSDSingle.xsd';
                    xslFileName := 'tempXSLSingle.xsl';
                    folderName := 'foo';
                    dotnetA.XmlToHtml(folderName, xmlFileName, xsdFileName, xslFileName, returnText1);
                    //"ABCkjsdf;2323232\r\nABCkjsdf;2323232\r\nABCkjsdf;2323232\r\nABCkjsdf;2323232\r\nABCkjsdf;2323232"
                end;
            }


            action("ZipUnzip")
            {
                Caption = 'ZipUnzip';
                Promoted = true;
                PromotedCategory = Process;
                Image = Compress;
                ApplicationArea = All;

                trigger OnAction();
                var
                    dotnetA: Codeunit "ALV Zip Helper";
                    outputFileName: Text;
                    folderToZip: Text;
                    destinationFolderUnzip: Text;

                begin
                    outputFileName := '/zip/foo.zip';
                    folderToZip := 'foo';
                    destinationFolderUnzip := '/unzip';
                    dotnetA.PackageZip(outputFileName, folderToZip);
                    dotnetA.PackageUnzip(outputFileName, destinationFolderUnzip);
                end;
            }

            action("XMLTest")
            {
                Caption = 'XMLTest';
                Promoted = true;
                PromotedCategory = Process;
                Image = Compress;
                ApplicationArea = All;

                trigger OnAction();
                var
                    AVInstream: InStream;
                    AVXmlDocument: XmlDocument;
                    AVXmlDocumentRoot: XmlElement;
                    AVXmlNodeList: XmlNodeList;
                    AVXmlNode: XmlNode;
                    XmlCustomText: Text;
                    StringBuilder: TextBuilder;
                    len: Integer;
                    i: Integer;
                    NodeText: Text;
                begin
                    AVXmlDocument := XmlDocument.Create();
                    XmlCustomText := '';

                    StringBuilder.Append('<headers>');
                    StringBuilder.Append('<to>alberto@valenti.com</to>');
                    StringBuilder.Append('<from>alberto@valenti</from>');
                    StringBuilder.Append('<subject>This is a sample mail.</subject>');
                    StringBuilder.Append('</headers>');

                    XmlCustomText := StringBuilder.ToText();
                    XmlDocument.ReadFrom(XmlCustomText, AVXmlDocument);
                    AVXmlDocument.GetRoot(AVXmlDocumentRoot);

                    if not AVXmlDocumentRoot.SelectNodes('/headers/to', AVXmlNodeList) then exit;
                    for i := 1 to AVXmlNodeList.Count() do begin
                        AVXmlNodeList.Get(i, AVXmlNode);
                        NodeText := AVXmlNode.AsXmlElement().InnerText();
                    end;

                end;
            }

        }
    }


}

