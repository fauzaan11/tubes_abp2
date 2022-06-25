class WisataType {
  int id;
  String namaWisata;
  String alamat;
  String foto;
  double totalRating;
  String deskripsi;
  WisataType(this.id, this.namaWisata, this.alamat, this.foto, this.totalRating,
      this.deskripsi);
}

class EventType {
  int id;
  String namaEvent;
  String tanggal;
  String alamat;
  String foto;
  EventType(this.namaEvent, this.alamat, this.tanggal, this.foto, this.id);
}

class FeedbackType {
  String deskripsi;
  double rating;
  String dari;
  FeedbackType(this.deskripsi, this.rating, this.dari);
}
