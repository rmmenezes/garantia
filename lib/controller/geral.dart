import 'package:appcertificate/models/certficadoModel.dart';
class FormsController {
  submitFormCertificado(_formKey, uid, nomeCliente, dataGarantia, codigoJoia,
      banho, cpf, descricao, vendedor) {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      CertificadoModel certificado = CertificadoModel(
        uid: uid,
        nomeCliente: nomeCliente,
        data: dataGarantia,
        codigoJoia: codigoJoia,
        descricao: descricao,
        vendedor: vendedor,
        banho: banho,
        cpf: cpf,
      );
      return certificado;
    }
  }
}

class SharePages {}
