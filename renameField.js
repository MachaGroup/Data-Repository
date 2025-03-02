import { db } from "./firebaseConfig.js";
import { collection, getDocs, updateDoc, doc, deleteField } from "firebase/firestore";

const renameBuildingID = async () => {
  try {
    const collectionRef = collection(db, "building_ID"); // Reference to the collection
    const snapshot = await getDocs(collectionRef); // Fetch all documents

    for (const document of snapshot.docs) {
      const data = document.data();

      if (data.building_ID) {
        await updateDoc(doc(db, "building_ID", document.id), {
          Assessment_ID: data.building_ID, // Copy value
          Building_ID: deleteField() // Remove old field
        });

        console.log(`✅ Updated ${document.id}: building_ID → Assessment_ID`);
      }
    }

    console.log("🎉 Field renaming complete!");
  } catch (error) {
    console.error("❌ Error updating documents:", error);
  }
};

renameBuildingID();
