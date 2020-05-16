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
        field(6; "AzureUri"; Text[250])
        {
        }
        field(7; "AzureUsername"; Text[250])
        {
        }
        field(8; "AzurePassword"; Text[250])
        {
        }
        field(9; "AzureWorkingPath"; Text[250])
        {
        }

        field(12; "AzureToken"; Text[250])
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

