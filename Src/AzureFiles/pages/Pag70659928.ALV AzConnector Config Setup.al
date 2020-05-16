page 70659928 "ALV AzConnector Config Setup"
{
    Caption = 'ALV AzConnector Config Setup';
    Editable = false;
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
                field("AzureUri"; "AzureUri")
                {
                    ApplicationArea = All;
                    Caption = 'Uri';
                }

                field("AzureToken"; "AzureToken")
                {
                    ApplicationArea = All;
                    Caption = 'Token';
                }
                field("AzureUsername"; "AzureUsername")
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                }
                field("AzurePassword"; "AzurePassword")
                {
                    ApplicationArea = All;
                    Caption = 'Password';
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

