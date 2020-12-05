enum DocumentType { License, RC, PUC, Insurance, PAN, Aadhar, others }

class Document {
  final String name, url;
  DocumentType type;

  Document({this.name, this.url}) {
    this.type = getType(this.name);
  }

  static DocumentType getType(String name) {
    DocumentType doc;
    switch (name.toLowerCase()) {
      case 'license':
        doc = DocumentType.License;
        break;
      case 'rc':
        doc = DocumentType.RC;
        break;
      case 'puc':
        doc = DocumentType.PUC;
        break;
      case 'insurance':
        doc = DocumentType.Insurance;
        break;
      case 'pan':
        doc = DocumentType.PAN;
        break;
      case 'aadhar':
        doc = DocumentType.Aadhar;
        break;
      default:
        doc = DocumentType.others;
        break;
    }
    return doc;
  }
}
