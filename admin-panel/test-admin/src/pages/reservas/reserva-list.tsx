import { List, Datagrid, TextField, DateField } from 'react-admin';

const reservasList = () => (
<List perPage={10}>
        <Datagrid>
            <TextField source="personas" label= "Personas" />
            <DateField source="fechaInicio" label= "Inicio reserva"/>
            <DateField source="fechaFin" label= "Fin reserva" />
        </Datagrid>
    </List>
);

export default reservasList;