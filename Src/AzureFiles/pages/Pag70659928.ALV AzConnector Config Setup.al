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

    }


}

