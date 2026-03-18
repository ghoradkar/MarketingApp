
import 'dart:convert';

BusinessListModel businessListModelFromJson(String str) => BusinessListModel.fromJson(json.decode(str));

String businessListModelToJson(BusinessListModel data) => json.encode(data.toJson());

class BusinessListModel {
    BusinessListModel({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory BusinessListModel.fromJson(Map<dynamic, dynamic> json) => BusinessListModel(
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
        required this.paidInvoice,
        required this.paidInvoiceAmount,
        required this.noOfCustomer,
        required this.srno,
        required this.invdate,
        required this.invoiceAmount,
        required this.unPaidInvoiceAmount,
        required this.date,
        required this.unPaidInvoice,
    });

    int paidInvoice;
    double paidInvoiceAmount;
    int noOfCustomer;
    int srno;
    String invdate;
    double invoiceAmount;
    double unPaidInvoiceAmount;
    String date;
    int unPaidInvoice;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        paidInvoice: json["PaidInvoice"],
        paidInvoiceAmount: json["PaidInvoiceAmount"],
        noOfCustomer: json["NoOfCustomer"],
        srno: json["SRNO"],
        invdate: json["Invdate"],
        invoiceAmount: json["InvoiceAmount"],
        unPaidInvoiceAmount: json["UnPaidInvoiceAmount"],
        date: json["Date"],
        unPaidInvoice: json["UnPaidInvoice"],
    );

    Map<dynamic, dynamic> toJson() => {
        "PaidInvoice": paidInvoice,
        "PaidInvoiceAmount": paidInvoiceAmount,
        "NoOfCustomer": noOfCustomer,
        "SRNO": srno,
        "Invdate": invdate,
        "InvoiceAmount": invoiceAmount,
        "UnPaidInvoiceAmount": unPaidInvoiceAmount,
        "Date": date,
        "UnPaidInvoice": unPaidInvoice,
    };
}
