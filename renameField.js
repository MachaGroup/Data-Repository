const { db } = require("./firebaseConfig.js");
const { collection, getDocs, updateDoc, doc, deleteField } = require("firebase/firestore");

const renameBuildingID = async () => {
  try {
    const collectionRef = collection(db, "Building_ID"); // Collection name
    const snapshot = await getDocs(collectionRef); // Fetch all documents

    for (const document of snapshot.docs) {
      const data = document.data();

      if (data.Building_ID) { // If the document has "Building_ID"
        await updateDoc(doc(db, "Building_ID", document.id), {
          Assessment_ID: data.Building_ID, // Copy value
          Building_ID: deleteField() // Remove the old field
        });

        console.log(`✅ Updated ${document.id}: Building_ID → Assessment_ID`);
      }
    }

    console.log("🎉 Field renaming complete!");
  } catch (error) {
    console.error("❌ Error updating documents:", error);
  }
};

// Run the script
renameBuildingID();
