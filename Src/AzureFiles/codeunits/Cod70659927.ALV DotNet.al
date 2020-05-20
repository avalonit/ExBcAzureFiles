codeunit 70659927 "ALV DotNetActivity"
{
    procedure EncodeB64(textFromInStream: Text) ReturnValue: Text
    var
        encodedString: Text;
        tempblob: Codeunit "Temp Blob";
        base64: Codeunit "Base64 Convert";
        oStream: OutStream;
        iStream: InStream;
    begin
        //https://www.kauffmann.nl/2017/07/10/convert-base64-with-al-code/
        //https://github.com/microsoft/ALAppExtensions/tree/master/Modules/System/Base64%20Convert
        //byte[] bytesToConvert = Encoding.Unicode.GetBytes(textFromInStream);
        //string encodedString = Convert.ToBase64String(bytesToConvert);
        //Tricky blob to change encoding to Unicode
        tempblob.CreateOutStream(oStream, TextEncoding::UTF16);
        oStream.WriteText(textFromInStream);
        tempblob.CreateInStream(iStream, TextEncoding::UTF16);
        ReturnValue := base64.ToBase64(iStream);
    end;

    procedure DecodeB64(textFromInStream: Text) ReturnValue: Text
    var
        decodedString: Text;
        base64: Codeunit "Base64 Convert";
    begin
        ReturnValue := base64.FromBase64(textFromInStream);
    end;


    //AV:99396
    procedure XmlToHtml(folderName: Text; xmlFileName: Text; xsdFileName: Text; xslFileName: Text; output: Text) ReturnValue: Text
    var
        xmlDomMgt: Codeunit "XML DOM Management";
        azFileManagement: codeunit "ALV AzAzure File Service API";
        xmlBuffer: Text;
        xsdBuffer: Text;
        xslBuffer: Text;
        csvBuffer: Text;
    begin
        //https://app365azurefiles.file.core.windows.net/to-increase/foo/tempXMLSingleIn.xsd
        //https://app365azurefiles.file.core.windows.net/to-increase/foo/tempXSDSingle.xsd
        //https://app365azurefiles.file.core.windows.net/to-increase/foo/tempXSLSingle.xsd

        azFileManagement.Download(folderName, xmlFileName, xmlBuffer);
        azFileManagement.Download(folderName, xsdFileName, xsdBuffer);
        azFileManagement.Download(folderName, xslFileName, xslBuffer);
        //xmlStream.ReadText(xmlBuffer);
        csvBuffer := xmlDomMgt.TransformXMLText(xmlBuffer, xslBuffer);
    end;


}
