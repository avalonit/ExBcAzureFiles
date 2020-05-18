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
                    returnText: Text;
                    opResult: Boolean;
                begin
                    opResult := fileService.List('foo', returnText);

                    if (opResult = false) then begin
                        Message('Error');
                    end
                    else begin
                        Message(returnText);
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
                    opResult: Boolean;
                begin
                    opResult := fileService.GetFile('foo', 'sample2.txt', returnText);

                    if (opResult = false) then begin
                        Message('Error');
                    end
                    else begin
                        Message(returnText);
                    end;

                end;
            }


        }
    }


}

