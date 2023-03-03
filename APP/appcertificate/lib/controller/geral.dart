import 'package:appcertificate/models/certficadoModel.dart';

class FormsController {
  submitFormCertificado(_formKey, uid, nomeCliente, dataGarantia, codigoJoia,
      descricao, vendedor) {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      CertificadoModel certificado = CertificadoModel(
          uid: uid,
          nomeCliente: nomeCliente,
          data: dataGarantia,
          codigoJoia: codigoJoia,
          descricao: descricao,
          vendedor: vendedor);
      return certificado;
    }
  }
}

class SharePages {

}