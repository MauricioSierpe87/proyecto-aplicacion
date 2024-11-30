String? Validator_Mail(String? value)
{
  if (value == null || value.isEmpty)
    return 'Por favor, ingrese su correo electrónico';
  
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  
  if (!emailRegex.hasMatch(value))
    return 'Ingrese un correo válido';

  return null;
}

String? Validator_Password(String? value)
{
  if (value == null || value.isEmpty)
    return 'Por favor, ingrese su contraseña';

  if (value.length < 8)
    return 'La contraseña debe tener al menos 8 caracteres';
    
  // Verificar caracteres específicos según ISO 27001
  final hasUppercase = value.contains(RegExp(r'[A-Z]'));
  final hasLowercase = value.contains(RegExp(r'[a-z]'));
  final hasDigits = value.contains(RegExp(r'\d'));
  final hasSpecialCharacters = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  if (!hasUppercase)
    return 'La contraseña debe incluir al menos una letra mayúscula';

  if (!hasLowercase)
    return 'La contraseña debe incluir al menos una letra minúscula';
    
  if (!hasDigits)
    return 'La contraseña debe incluir al menos un número';
    
  if (!hasSpecialCharacters)
    return 'La contraseña debe incluir al menos un carácter especial (!@#\$%^&*)';

  return null; // Contraseña válida
}

String? Validator_Password_Login(String? value)
{
  if(value == null || value.isEmpty)
    return 'Contraseña vacía';

  return null;
}