using Godot;
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public partial class GlobalKeyboard : Node
{
	[Signal]
	public delegate void KeyPressedEventHandler();

	private IntPtr hookId = IntPtr.Zero;
	private LowLevelKeyboardProc proc;

	public override void _Ready()
	{
		proc = HookCallback;
		hookId = SetHook(proc);
	}

	public override void _ExitTree()
	{
		UnhookWindowsHookEx(hookId);
	}

	private IntPtr SetHook(LowLevelKeyboardProc proc)
	{
		using Process curProcess = Process.GetCurrentProcess();
		using ProcessModule curModule = curProcess.MainModule;

		return SetWindowsHookEx(
			WH_KEYBOARD_LL,
			proc,
			GetModuleHandle(curModule.ModuleName),
			0
		);
	}

	private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

	private IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
	{
		if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN)
		{
			CallDeferred(nameof(EmitKeyPressed));
		}

		return CallNextHookEx(hookId, nCode, wParam, lParam);
	}

	public void EmitKeyPressed()
	{
		GD.Print("Key pressed!");
		EmitSignal(SignalName.KeyPressed);
	}

	private const int WH_KEYBOARD_LL = 13;
	private const int WM_KEYDOWN = 0x0100;

	[DllImport("user32.dll")]
	private static extern IntPtr SetWindowsHookEx(
		int idHook,
		LowLevelKeyboardProc lpfn,
		IntPtr hMod,
		uint dwThreadId
	);

	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool UnhookWindowsHookEx(IntPtr hhk);

	[DllImport("user32.dll")]
	private static extern IntPtr CallNextHookEx(
		IntPtr hhk,
		int nCode,
		IntPtr wParam,
		IntPtr lParam
	);

	[DllImport("kernel32.dll")]
	private static extern IntPtr GetModuleHandle(string lpModuleName);
}
