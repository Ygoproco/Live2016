--Double Cloth Armor
function c110000120.initial_effect(c)
	--Cannot Attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e1)
    --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(110000107,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c110000120.destg)
	e2:SetOperation(c110000120.desop)
	c:RegisterEffect(e2)
    if not c110000120.global_check then
		c110000120.global_check=true
		if Duel.GetFlagEffect(0,110000104)==0 and Duel.GetFlagEffect(1,110000104)==0 then
			Duel.RegisterFlagEffect(0,110000104,0,0,1)
			Duel.RegisterFlagEffect(1,110000104,0,0,1)
			--cannot attack
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			ge1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			ge1:SetCondition(c110000120.atkcon)
			ge1:SetTarget(c110000120.atktg)
			Duel.RegisterEffect(ge1,0)
			--check
			local ge2=Effect.CreateEffect(c)
			ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			ge2:SetCode(EVENT_ATTACK_ANNOUNCE)
			ge2:SetOperation(c110000120.checkop)
			ge2:SetLabelObject(ge1)
			Duel.RegisterEffect(ge2,0)
			--change attack target
			local ge3=Effect.CreateEffect(c)
			ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge3:SetCode(EVENT_BE_BATTLE_TARGET)
			ge3:SetCondition(c110000120.atcon)
			ge3:SetOperation(c110000120.atop)
			Duel.RegisterEffect(ge3,0)
			local ge4=ge3:Clone()
			Duel.RegisterEffect(ge4,1)
		end
	end
end
function c110000120.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),110000103)~=0 and Duel.GetFlagEffect(1-e:GetHandlerPlayer(),110000103)~=0
end
function c110000120.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel() and c:IsType(0x10000000)
end
function c110000120.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if not a:IsType(0x10000000) then return end
	if Duel.GetFlagEffect(tp,110000103)~=0 and Duel.GetFlagEffect(1-tp,110000103)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,110000103,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,110000103,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c110000120.atcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsType(0x10000000)
end
function c110000120.filter(c)
	return c:IsFaceup() and c:IsType(0x10000000)
end
function c110000120.atop(e,tp,eg,ep,ev,re,r,rp)
	local atg=Duel.GetAttacker():GetAttackableTarget()
	local d=Duel.GetAttackTarget()
	if atg:IsExists(c110000120.filter,1,d) and Duel.SelectYesNo(tp,aux.Stringid(21558682,0)) then
		local g=atg:FilterSelect(tp,c110000120.filter,1,1,d)
		Duel.HintSelection(g)
		Duel.ChangeAttackTarget(g:GetFirst())
	end
end
function c110000120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget() and Duel.GetAttackTarget()==c end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetAttacker():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c110000120.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=Duel.GetAttacker()
	if c:IsRelateToBattle() then g:AddCard(c) end
	Duel.Damage(1-tp,c:GetAttack()/2,REASON_EFFECT)
	c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		Duel.Destroy(g,nil,REASON_EFFECT)
	end
end
