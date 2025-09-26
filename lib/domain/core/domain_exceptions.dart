class DomainException implements Exception {
  DomainException();
}

class InvalidQuantityException extends DomainException {
  InvalidQuantityException();
}

class InvalidSteamIdUrlException extends DomainException {
  InvalidSteamIdUrlException();
}

class InvalidUrlException extends DomainException {
  InvalidUrlException();
}

class NullPartnerSteamIdException extends DomainException {
  NullPartnerSteamIdException();
}
