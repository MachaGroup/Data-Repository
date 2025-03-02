import { db } from "./firebaseConfig.js";
import { collection, getDocs, updateDoc, doc, deleteField } from "firebase/firestore";

const renameBuildingId = async () => {
  try {
    const collectionRef = collection(db, "Buildings"); // ✅ Correct collection name
    const snapshot = await getDocs(collectionRef); // Fetch all documents

    if (snapshot.empty) {
      console.log("❌ No documents found in the 'Buildings' collection.");
      return;
    }

    for (const document of snapshot.docs) {
      const data = document.data();
      console.log(`📌 Checking Document ID: ${document.id}`, data); // Log document data

      if (data.buildingId) { // ✅ Correct field name
        console.log(`✅ Updating document ${document.id}...`);
        await updateDoc(doc(db, "Buildings", document.id), {
          assessmentId: data.buildingId, // Copy value
          buildingId: deleteField() // Remove old field
        });

        console.log(`✔️ Successfully updated ${document.id}`);
      } else {
        console.log(`⚠️ Skipping ${document.id} - No 'buildingId' field found.`);
      }
    }

    console.log("🎉 Field renaming complete!");
  } catch (error) {
    console.error("❌ Error updating documents:", error);
  }
};

// Run the script
renameBuildingId();
