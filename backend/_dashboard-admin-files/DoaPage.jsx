// Copy file ini ke: dashboard-admin/src/pages/admin/hudhud/doa/DoaPage.jsx

import React, { useState, useEffect } from "react";
import {
  Box,
  Button,
  ButtonGroup,
  useDisclosure,
  useToast,
  AlertDialog,
  AlertDialogBody,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogContent,
  AlertDialogOverlay,
  Badge,
  Select,
} from "@chakra-ui/react";
import TableDinamis from "@/components/util/dynamic/tableDinamis";
import ModalForm from "@/components/util/dynamic/formDinamis";
import marbotApi from "@/services/marbotApi";

const DoaPage = () => {
  const toast = useToast();
  const { isOpen, onOpen, onClose } = useDisclosure();
  const cancelRef = React.useRef();

  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState({});
  const [selectID, setSelectID] = useState(null);
  const [isEditMode, setIsEditMode] = useState(false);
  const [refresh, setRefresh] = useState(0);
  const [deleteId, setDeleteId] = useState(null);

  const [kategoriOptions, setKategoriOptions] = useState([]);

  useEffect(() => {
    const loadKategori = async () => {
      try {
        const res = await marbotApi.get("/doa/kategori");
        const list = res.data || res || [];
        setKategoriOptions(
          list.map((k) => ({ label: k.nama, value: String(k.id) })),
        );
      } catch {
        // ignore
      }
    };
    loadKategori();
  }, [refresh]);

  const buildFormFields = (data = {}) => ({
    judul: {
      label: "Judul",
      value: data.judul ?? "",
      type: "text",
      validation: { required: true, message: "Judul wajib diisi" },
    },
    teks_arab: {
      label: "Teks Arab",
      value: data.teks_arab ?? "",
      type: "textarea",
      validation: { required: true, message: "Teks arab wajib diisi" },
    },
    teks_latin: {
      label: "Teks Latin",
      value: data.teks_latin ?? "",
      type: "textarea",
    },
    terjemahan: {
      label: "Terjemahan",
      value: data.terjemahan ?? "",
      type: "textarea",
      validation: { required: true, message: "Terjemahan wajib diisi" },
    },
    riwayat: {
      label: "Riwayat",
      value: data.riwayat ?? "",
      type: "text",
    },
    kategori_id: {
      label: "Kategori",
      value: data.kategori_id ? String(data.kategori_id) : "",
      type: "dropdown",
      options: [
        { label: "- Tanpa Kategori -", value: "" },
        ...kategoriOptions,
      ],
    },
  });

  const handleAdd = () => {
    setIsEditMode(false);
    setFormData(buildFormFields());
    setShowModal(true);
  };

  const handleEdit = async (id) => {
    try {
      const result = await marbotApi.get(`/doa/${id}`);
      const data = result.data || result;
      setSelectID(id);
      setIsEditMode(true);
      setFormData(buildFormFields(data));
      setShowModal(true);
    } catch {
      toast({
        title: "Error",
        description: "Gagal mengambil data Doa",
        status: "error",
        duration: 3000,
      });
    }
  };

  const handleSave = async (values) => {
    try {
      const payload = { ...values };
      if (payload.kategori_id) payload.kategori_id = Number(payload.kategori_id);
      else delete payload.kategori_id;

      if (!isEditMode) {
        await marbotApi.post("/doa", payload);
        toast({ title: "Sukses", description: "Doa berhasil ditambahkan", status: "success" });
      } else {
        await marbotApi.put(`/doa/${selectID}`, payload);
        toast({ title: "Sukses", description: "Doa berhasil diupdate", status: "success" });
      }
      setRefresh((p) => p + 1);
      setShowModal(false);
    } catch (error) {
      toast({
        title: "Error",
        description: error.response?.data?.message || error.message || "Terjadi kesalahan",
        status: "error",
      });
    }
  };

  const handleDelete = (id) => {
    setDeleteId(id);
    onOpen();
  };

  const confirmDelete = async () => {
    try {
      await marbotApi.delete(`/doa/${deleteId}`);
      toast({ title: "Sukses", description: "Doa berhasil dihapus", status: "success" });
      setRefresh((p) => p + 1);
    } catch (error) {
      toast({
        title: "Error",
        description: error.response?.data?.message || "Gagal menghapus Doa",
        status: "error",
      });
    }
    onClose();
  };

  return (
    <Box p={4}>
      {showModal && (
        <ModalForm
          visible={showModal}
          onHide={() => setShowModal(false)}
          onSave={handleSave}
          formData={formData}
          isEditMode={isEditMode}
          header={isEditMode ? "Edit Doa" : "Tambah Doa"}
        />
      )}

      <AlertDialog isOpen={isOpen} leastDestructiveRef={cancelRef} onClose={onClose}>
        <AlertDialogOverlay>
          <AlertDialogContent>
            <AlertDialogHeader>Konfirmasi Hapus</AlertDialogHeader>
            <AlertDialogBody>Apakah Anda yakin ingin menghapus Doa ini?</AlertDialogBody>
            <AlertDialogFooter>
              <Button ref={cancelRef} onClick={onClose}>Batal</Button>
              <Button colorScheme="red" onClick={confirmDelete} ml={3}>Hapus</Button>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialogOverlay>
      </AlertDialog>

      <TableDinamis
        id="hudhud-doa"
        api={marbotApi}
        path="/doa"
        queryParams={{}}
        title="Daftar Doa"
        headerComponents={[
          () => (
            <Button colorScheme="blue" onClick={handleAdd}>
              Tambah Doa
            </Button>
          ),
        ]}
        onRefresh={refresh}
        sortFieldDefault="id"
        sortOrderDefault={1}
        kolom={[
          { field: "judul", label: "Judul", sort: true },
          { field: "kategori_id", label: "Kategori", sort: true },
          { field: "riwayat", label: "Riwayat", sort: false },
        ]}
        actionButtonTemplate={(rowData) => (
          <ButtonGroup size="sm" spacing={2}>
            <Button colorScheme="yellow" onClick={() => handleEdit(rowData.id)}>
              Edit
            </Button>
            <Button colorScheme="red" onClick={() => handleDelete(rowData.id)}>
              Hapus
            </Button>
          </ButtonGroup>
        )}
      />
    </Box>
  );
};

export default DoaPage;
