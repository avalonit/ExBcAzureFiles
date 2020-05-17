table 70659927 "ALV AzConnector Configuration"
{
    fields
    {
        field(1; "AzureNo"; Integer)
        {
        }
        field(2; "AzureCode"; Code[20])
        {
            NotBlank = true;
        }

        field(8; "AzurePassword"; Text[250])
        {
        }
        field(9; "AzureWorkingPath"; Text[250])
        {
        }

        field(6; "AzureUri"; Text[250])
        {
            ObsoleteState = Removed;
        }
        field(7; "AzureUsername"; Text[250])
        {
            ObsoleteState = Removed;
        }
        field(12; "AzureToken"; Text[250])
        {
            ObsoleteState = Removed;
        }

        field(13; "AzureBlobUri"; Text[250])
        {
        }
        field(14; "AzureBlobUsername"; Text[250])
        {
        }
        field(15; "AzureBlobPassword"; Text[250])
        {
        }
        field(16; "AzureBlobToken"; Text[250])
        {
        }

        field(17; "AzureFunctionUri"; Text[250])
        {
        }
        field(18; "AzureFunctionKey"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "AzureNo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

