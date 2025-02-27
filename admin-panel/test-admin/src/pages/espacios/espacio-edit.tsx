import {
  ArrayField,
  BooleanInput,
  Datagrid,
  Edit,
  NumberInput,
  SimpleForm,
  TextField,
  TextInput,
} from "react-admin";

const espacioEdit = () => (
  <Edit>
    <SimpleForm>
      <TextInput source="name" />
      <NumberInput source="quantity" />
      <BooleanInput source="available" />
      <ArrayField source="elementos" label="Elementos">
        {/* TODO: Hacer que se puedan quitar o agregar elementos aca */}
        <Datagrid bulkActionButtons={false} rowClick={false}>
          <TextField source="name" />
          <TextField source="quantity" />
          <TextField source="available" />
        </Datagrid>
      </ArrayField>
    </SimpleForm>
  </Edit>
);

export default espacioEdit;
