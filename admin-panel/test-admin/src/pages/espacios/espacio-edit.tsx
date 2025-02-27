import axios from "axios";
import { BooleanInput, Edit, NumberInput, SimpleForm, TextInput, useGetList, SelectArrayInput, useNotify, useRedirect, useRefresh, useRecordContext } from "react-admin";


const EspacioEdit = () => {
  const notify = useNotify();
  const redirect = useRedirect();
  const refresh = useRefresh();
  const record = useRecordContext(); // Accede al registro del espacio
  const id = record?.id;

  const { data: elementos, isLoading } = useGetList("elementos", {
    pagination: { page: 1, perPage: 1000 },
  });

  const handleEdit = async (data: any) => {
    try {
      await axios.put(`http://localhost:3000/api/espacios/${data.id}`, {
        name: data.name,
        quantity: data.quantity,
        elementos: data.elementos || [],
      });

      notify("Espacio editado exitosamente");
      redirect("/espacios");
      refresh();
    } catch (error) {
      notify("Error al editar espacio", { type: "error" });
    }
  };

  return (
    <Edit>
      <SimpleForm onSubmit={handleEdit} sanitizeEmptyValues>
        <TextInput source="name" />
        <NumberInput source="quantity" />
        <BooleanInput source="available" />
        <SelectArrayInput
          source="elementos"
          label="Elementos existentes"
          choices={elementos || []}
          optionText="name"
          optionValue="id"
          format={(value) => value?.map((item: any) => item.id) || []} // Transforma objetos a IDs
          parse={(value) => value?.map((id: number) => ({ id })) || []} // Transforma IDs a objetos
          isLoading={isLoading}
          fullWidth
        />
      </SimpleForm>
    </Edit>
  );
};

export default EspacioEdit;