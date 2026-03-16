import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../domain/entities/task.dart';
import 'providers/task_provider.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;

  const TaskFormScreen({super.key, this.taskId});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.pending;
  DateTime? _dueDate;

  bool get isEditing => widget.taskId != null;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initFromExistingTask(WidgetRef ref) {
    if (_initialized || !isEditing) return;
    _initialized = true;

    final task = ref.read(taskProvider.notifier).getTaskById(widget.taskId!);
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _priority = task.priority;
      _status = task.status;
      _dueDate = task.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initFromExistingTask(ref);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarea' : 'Nueva tarea'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded, size: 20),
            label: const Text('Guardar'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── Título ───
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título *',
                hintText: 'Ej: Revisar informe mensual',
                prefixIcon: const Icon(Icons.title_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ─── Descripción ───
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                hintText: 'Detalles opcionales de la tarea…',
                prefixIcon: const Icon(Icons.notes_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),

            // ─── Prioridad ───
            Text(
              'Prioridad',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TaskPriority.values.map((p) {
                final selected = _priority == p;
                final color = Color(p.colorValue);
                return ChoiceChip(
                  label: Text(p.displayName),
                  selected: selected,
                  onSelected: (_) => setState(() => _priority = p),
                  selectedColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: selected ? color : theme.colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: selected ? color : theme.dividerColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ─── Estado ───
            Text(
              'Estado',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.flag_rounded),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                items: TaskStatus.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Color(s.colorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(s.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _status = v);
                },
              ),
            ),
            const SizedBox(height: 20),

            // ─── Fecha límite ───
            Text(
              'Fecha límite',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _dueDate != null
                            ? DateFormat('dd MMM yyyy').format(_dueDate!)
                            : 'Sin fecha límite',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _dueDate != null
                              ? null
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ),
                    if (_dueDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _dueDate = null),
                        child: Icon(
                          Icons.close_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ─── Botón guardar grande ───
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_rounded),
              label: Text(isEditing ? 'Actualizar tarea' : 'Crear tarea'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF2E7D32),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(taskProvider.notifier);

    if (isEditing) {
      notifier.updateTask(
        id: widget.taskId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        priority: _priority,
        status: _status,
        dueDate: _dueDate,
      );
    } else {
      notifier.addTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        priority: _priority,
        status: _status,
        dueDate: _dueDate,
      );
    }

    context.pop();
  }
}