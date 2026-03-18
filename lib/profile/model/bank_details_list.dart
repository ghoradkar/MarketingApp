
import 'dart:convert';

BankDetailsList bankDetailsListFromJson(String str) => BankDetailsList.fromJson(json.decode(str));

String bankDetailsListToJson(BankDetailsList data) => json.encode(data.toJson());

class BankDetailsList {
    BankDetailsList({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory BankDetailsList.fromJson(Map<dynamic, dynamic> json) => BankDetailsList(
        output: List<Output>.from(json["output"].map((x) => Output.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Output {
    Output({
        required this.bankname,
        required this.accountMaxLength,
        required this.accountMinLength,
        required this.bankid,
    });

    String bankname;
    int accountMaxLength;
    int accountMinLength;
    int bankid;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        bankname: json["BANKNAME"],
        accountMaxLength: json["AccountMaxLength"],
        accountMinLength: json["AccountMinLength"],
        bankid: json["BANKID"],
    );

    Map<dynamic, dynamic> toJson() => {
        "BANKNAME": bankname,
        "AccountMaxLength": accountMaxLength,
        "AccountMinLength": accountMinLength,
        "BANKID": bankid,
    };
}
