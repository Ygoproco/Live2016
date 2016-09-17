--オッドアイズ・ファントム・ドラゴン
function c511002702.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511002702.regcon)
	e1:SetOperation(c511002702.regop)
	c:RegisterEffect(e1)
	-- damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91711547,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c511002702.damcon)
	e2:SetTarget(c511002702.damtg)
	e2:SetOperation(c511002702.damop)
	c:RegisterEffect(e2)
end
function c511002702.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c511002702.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(511002702,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c511002702.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511002702)>0 and ep~=tp
end
function c511002702.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c511002702.damop(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	local rp1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rp2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rp1 then
		atk=atk+rp1:GetAttack()
	end
	if rp2 then
		atk=atk+rp2:GetAttack()
	end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,atk,REASON_EFFECT)
end
