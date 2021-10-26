package com.futurebrains;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.futurebrains.databinding.ActivitySchoolBinding;

import org.jitsi.meet.sdk.JitsiMeet;
import org.jitsi.meet.sdk.JitsiMeetActivity;
import org.jitsi.meet.sdk.JitsiMeetConferenceOptions;

public class ClassActivity extends AppCompatActivity {
    private String BASE_URL = "https://demo-eschool.examdo.co.in";

    private String DEEP_LINK_URL = "https://demo-eschool.examdo.co.in/deeplink?meetingId=GooglePlayStoreTest&jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwYjA2NWEwLTBmYTctMTFlYy1hMzM4LWNkYjdiOTBjZmM5ZCIsImVtYWlsIjoiZGVtb3RlYWNoZXJAZGVtby5jb20iLCJpbnN0aXR1dGUiOiJlZWVmNjAzMC0wZjlkLTExZWMtYTMzOC1jZGI3YjkwY2ZjOWQiLCJmaXJzdE5hbWUiOiJEZW1vIiwibGFzdE5hbWUiOiJUZWFjaGVyIiwiYXZhdGFyVXJsIjpudWxsLCJyb2xlTmFtZSI6IkxFQ1RVUkVSIiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsIm5hbWUiOiJEZW1vIFRlYWNoZXIiLCJlbWFpbCI6ImRlbW90ZWFjaGVyQGRlbW8uY29tIiwiYWZmaWxpYXRpb24iOiJvd25lciJ9fSwiYXVkIjoiaml0c2kiLCJpc3MiOiJmdXR1cmVicmFpbnMiLCJzdWIiOiJkZW1vLWVzY2hvb2wuZXhhbWRvLmNvLmluIiwicm9vbSI6IioiLCJpYXQiOjE2MzE4NjM4MzUsImV4cCI6MTYzMjk0MzgzNX0.Nu-3uTw7HVWycLw18j9a6C9KRX_LSSxT6NShbsUZ8Ks";

    private ActivitySchoolBinding binding;

    private String meetingId = "";
    private String jwt = "";

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        Uri deepLinkUri = intent.getData();
        if (deepLinkUri != null) {
            String linkedMeetingId = deepLinkUri.getQueryParameter("meetingId");
            if (linkedMeetingId != null && !linkedMeetingId.isEmpty())
                meetingId = linkedMeetingId;
            String linkedJwt = deepLinkUri.getQueryParameter("jwt");
            if (linkedJwt != null && !linkedJwt.isEmpty())
                jwt = linkedJwt;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
//        JitsiMeet.showSplashScreen(this);
        super.onCreate(savedInstanceState);

        Uri deepLinkUri = getIntent().getData();
        if (deepLinkUri != null) {
            String linkedMeetingId = deepLinkUri.getQueryParameter("meetingId");
            if (linkedMeetingId != null && !linkedMeetingId.isEmpty())
                meetingId = linkedMeetingId;
            String linkedJwt = deepLinkUri.getQueryParameter("jwt");
            if (linkedJwt != null && !linkedJwt.isEmpty())
                jwt = linkedJwt;
        }

        binding = ActivitySchoolBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setSupportActionBar(binding.toolbar);
        try {
            PackageInfo pInfo = getPackageManager().getPackageInfo(getPackageName(), 0);
            binding.tvAppVersion.setText("v" + pInfo.versionName);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        if (!meetingId.isEmpty() && !jwt.isEmpty())
            prepareJitsi();

        binding.btnLaunchClass.setOnClickListener(v -> {
            prepareJitsi();
        });
    }

    private void prepareJitsi() {
        if (!meetingId.isEmpty() && !jwt.isEmpty()) {
            launchJitsi();

        } else {
            if (binding.etMeetingId.getText().toString().isEmpty()) {
                Toast.makeText(this, "Please enter class", Toast.LENGTH_SHORT).show();
                return;
            }
            if (binding.etJwtToken.getText().toString().isEmpty()) {
                Toast.makeText(this, "Please enter token", Toast.LENGTH_SHORT).show();
                return;
            }
            meetingId = binding.etMeetingId.getText().toString();
            jwt = binding.etJwtToken.getText().toString();

            launchJitsi();
        }
    }

    private void launchJitsi() {
        JitsiMeetActivity.launch(
            this, new JitsiMeetConferenceOptions.Builder()
                .setRoom(BASE_URL + "/"+ meetingId + "?jwt=" + jwt)
                .setAudioMuted(true)
                .setVideoMuted(true)
                .build()
        );
        finish();
    }
}
