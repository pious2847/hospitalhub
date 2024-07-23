class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
  title: 'Dedicated Patient Care',
  image: 'assets/images/medical_care.svg',
  discription: "We prioritize your well-being with personalized, attentive care. Our dedicated team ensures you receive the support and treatment you need throughout your healthcare journey."
),
UnbordingContent(
  title: 'Expert Medical Team',
  image: 'assets/images/doctors.svg',
  discription: "Connect with our trusted network of experienced doctors and specialists. Receive personalized care from medical professionals dedicated to your health."
),
UnbordingContent(
  title: 'Medication Management',
  image: 'assets/images/medicine.svg',
  discription: "Keep track of your prescriptions and medication schedules effortlessly. Our app ensures you never miss a dose and helps manage your treatment effectively."
),
 
  
];