import { Show, SimpleShowLayout, TextField, ArrayField, Datagrid, List, ListGuesser, SimpleList} from 'react-admin';

const espaciosShow = (props: any) => ( 
    <Show {...props}>
        <SimpleShowLayout>
            <TextField source="name" label="Nombre" />
            <TextField source="quantity" label="Quantity" />
            <TextField source="available" label="Disponible" />
            <ArrayField source="elementos" label="Elementos">
                <SimpleList
                    primaryText={elemento => elemento.name}
                    secondaryText={elemento => elemento.quantity>1 ? `Cantidad: ${elemento.quantity}` : ""}
                    tertiaryText={elemento => elemento.available ? "Disponible" : "No disponible"}
                    // cli
                    // rowClick={(record: any) => record.canEdit ? "edit" : "show"}
                    // rowSx={record => ({ backgroundColor: record.nb_views >= 500 ? '#efe' : 'white' })}
                />
            </ArrayField>
        </SimpleShowLayout>
    </Show>
);

export default espaciosShow;